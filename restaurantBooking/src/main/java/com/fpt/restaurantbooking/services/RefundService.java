package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.models.Payment;
import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.repositories.impl.ReservationTableDAO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Service for calculating refunds based on cancellation rules
 */
public class RefundService {
    private static final Logger logger = LoggerFactory.getLogger(RefundService.class);
    
    // Thời gian tối thiểu trước giờ đặt để được hoàn tiền (2 giờ)
    private static final int CANCELLATION_DEADLINE_HOURS = 2;
    
    /**
     * Calculate refund amount based on cancellation rules
     * 
     * @param reservation Reservation being cancelled
     * @param payment Payment information
     * @param cancellationTime Time when cancellation happens
     * @param isNoShow true if customer didn't show up, false if cancelled
     * @return RefundResult containing refund amount and reason
     */
    public RefundResult calculateRefund(Reservation reservation, Payment payment, 
                                        LocalDateTime cancellationTime, boolean isNoShow) {
        if (reservation == null || payment == null) {
            return new RefundResult(BigDecimal.ZERO, "Không có thông tin thanh toán", false);
        }
        
        String paymentMethod = payment.getPaymentMethod();
        BigDecimal totalAmount = BigDecimal.valueOf(payment.getAmount());
        
        // Tính thời gian từ lúc hủy đến giờ đặt bàn
        LocalDateTime reservationDateTime = reservation.getReservationDate()
                .atTime(reservation.getReservationTime());
        long hoursBeforeReservation = ChronoUnit.HOURS.between(cancellationTime, reservationDateTime);
        
        // Case 1: Thanh toán khi đến nơi (CASH)
        if ("CASH".equals(paymentMethod)) {
            return calculateCashRefund(reservation, payment, hoursBeforeReservation, isNoShow);
        }
        
        // Case 2: Thanh toán toàn bộ online (VNPAY)
        if ("VNPAY".equals(paymentMethod)) {
            return calculateVnPayRefund(totalAmount, hoursBeforeReservation, isNoShow);
        }
        
        // Các phương thức khác: không hoàn tiền
        return new RefundResult(BigDecimal.ZERO, "Phương thức thanh toán không hỗ trợ hoàn tiền", false);
    }
    
    /**
     * Calculate refund for CASH payment (deposit only)
     */
    private RefundResult calculateCashRefund(Reservation reservation, Payment payment,
                                            long hoursBeforeReservation, boolean isNoShow) {
        // Tính tiền cọc: 20,000 VNĐ/bàn
        int tableCount = 0;
        BigDecimal depositAmount = BigDecimal.ZERO;
        
        try {
            // Lấy số bàn từ Reservation_Tables
            ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
            List<Integer> tableIds = reservationTableDAO.getTablesByReservationId(reservation.getReservationId());
            tableCount = (tableIds != null) ? tableIds.size() : 0;
            
            if (tableCount > 0) {
                depositAmount = BigDecimal.valueOf(tableCount * 20000L);
            } else {
                // Fallback: parse từ payment notes hoặc amount
                String notes = payment.getNotes();
                if (notes != null && notes.contains("Deposit:")) {
                    try {
                        String depositStr = notes.substring(notes.indexOf("Deposit:") + 8);
                        depositStr = depositStr.substring(0, depositStr.indexOf("VNĐ")).trim();
                        depositStr = depositStr.replaceAll("[^0-9]", "");
                        long deposit = Long.parseLong(depositStr);
                        depositAmount = BigDecimal.valueOf(deposit);
                    } catch (Exception e) {
                        logger.warn("Could not parse deposit from notes, using payment amount", e);
                        depositAmount = BigDecimal.valueOf(payment.getAmount());
                    }
                } else {
                    // Với CASH, amount thường là deposit amount
                    depositAmount = BigDecimal.valueOf(payment.getAmount());
                }
            }
        } catch (Exception e) {
            logger.warn("Could not calculate deposit amount, using payment amount", e);
            depositAmount = BigDecimal.valueOf(payment.getAmount());
        }
        
        // No-show: Không hoàn tiền cọc
        if (isNoShow) {
            return new RefundResult(BigDecimal.ZERO, 
                    "Không hoàn tiền cọc do khách không đến (no-show)", false);
        }
        
        // Hủy trước hạn (≥ 2 giờ): Hoàn tiền cọc
        if (hoursBeforeReservation >= CANCELLATION_DEADLINE_HOURS) {
            return new RefundResult(depositAmount, 
                    "Hoàn lại tiền cọc do hủy trước hạn cho phép (≥ 2 giờ)", true);
        }
        
        // Hủy trễ (< 2 giờ): Không hoàn tiền cọc
        return new RefundResult(BigDecimal.ZERO, 
                "Không hoàn tiền cọc do hủy trễ (< 2 giờ trước giờ đặt)", false);
    }
    
    /**
     * Calculate refund for VNPAY payment (full payment)
     */
    private RefundResult calculateVnPayRefund(BigDecimal totalAmount, 
                                             long hoursBeforeReservation, boolean isNoShow) {
        // No-show: Không hoàn tiền
        if (isNoShow) {
            return new RefundResult(BigDecimal.ZERO, 
                    "Không hoàn tiền do khách không đến (no-show)", false);
        }
        
        // Hủy trước hạn (≥ 2 giờ): Hoàn 100%
        if (hoursBeforeReservation >= CANCELLATION_DEADLINE_HOURS) {
            return new RefundResult(totalAmount, 
                    "Hoàn 100% tiền do hủy trước hạn cho phép (≥ 2 giờ)", true);
        }
        
        // Hủy trễ (< 2 giờ): Hoàn 50%
        BigDecimal refundAmount = totalAmount.multiply(new BigDecimal("0.5"));
        return new RefundResult(refundAmount, 
                "Hoàn 50% tiền do hủy trễ (< 2 giờ trước giờ đặt)", true);
    }
    
    /**
     * Calculate deposit refund for completed order (CASH payment only)
     * When customer arrives and pays in full, deposit should be refunded
     */
    public RefundResult calculateDepositRefundForCompletedOrder(Payment payment, Reservation reservation) {
        if (payment == null || !"CASH".equals(payment.getPaymentMethod())) {
            return new RefundResult(BigDecimal.ZERO, "Không áp dụng", false);
        }
        
        // Tính tiền cọc từ số bàn thực tế
        BigDecimal depositAmount = BigDecimal.ZERO;
        try {
            ReservationTableDAO reservationTableDAO = new ReservationTableDAO();
            List<Integer> tableIds = reservationTableDAO.getTablesByReservationId(reservation.getReservationId());
            int tableCount = (tableIds != null) ? tableIds.size() : 0;
            
            if (tableCount > 0) {
                depositAmount = BigDecimal.valueOf(tableCount * 20000L);
            } else {
                // Fallback: parse từ payment notes hoặc amount
                String notes = payment.getNotes();
                if (notes != null && notes.contains("Deposit:")) {
                    try {
                        String depositStr = notes.substring(notes.indexOf("Deposit:") + 8);
                        depositStr = depositStr.substring(0, depositStr.indexOf("VNĐ")).trim();
                        depositStr = depositStr.replaceAll("[^0-9]", "");
                        depositAmount = BigDecimal.valueOf(Long.parseLong(depositStr));
                    } catch (Exception e) {
                        logger.warn("Could not parse deposit from notes, using payment amount", e);
                        depositAmount = BigDecimal.valueOf(payment.getAmount());
                    }
                } else {
                    // Nếu không có trong notes, giả sử amount là deposit
                    depositAmount = BigDecimal.valueOf(payment.getAmount());
                }
            }
        } catch (Exception e) {
            logger.warn("Could not calculate deposit amount, using payment amount", e);
            depositAmount = BigDecimal.valueOf(payment.getAmount());
        }
        
        return new RefundResult(depositAmount, 
                "Hoàn lại tiền cọc khi đơn hàng hoàn thành", true);
    }
    
    /**
     * Result class for refund calculation
     */
    public static class RefundResult {
        private final BigDecimal refundAmount;
        private final String reason;
        private final boolean eligible;
        
        public RefundResult(BigDecimal refundAmount, String reason, boolean eligible) {
            this.refundAmount = refundAmount;
            this.reason = reason;
            this.eligible = eligible;
        }
        
        public BigDecimal getRefundAmount() {
            return refundAmount;
        }
        
        public String getReason() {
            return reason;
        }
        
        public boolean isEligible() {
            return eligible;
        }
    }
}

