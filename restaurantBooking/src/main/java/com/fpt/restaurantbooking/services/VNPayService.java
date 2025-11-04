package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.utils.VNPayConfig;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.HashMap;
import java.util.Map;

/**
 * VNPay Service
 * Handles VNPay payment business logic
 */
public class VNPayService {
    private static final Logger logger = LoggerFactory.getLogger(VNPayService.class);

    /**
     * Create VNPay payment URL for reservation
     */
    public String createPaymentUrl(int reservationId, long amount, String orderDescription, String orderType) {
        try {
            Map<String, String> params = new HashMap<>();

            // Basic parameters
            params.put("vnp_Amount", VNPayConfig.formatAmount(amount));
            params.put("vnp_OrderInfo", orderDescription);
            params.put("vnp_OrderType", orderType != null ? orderType : "other");

            // Transaction reference
            String txnRef = String.valueOf(System.currentTimeMillis());
            params.put("vnp_TxnRef", txnRef);

            // Return and IPN URLs
            params.put("vnp_ReturnUrl", VNPayConfig.getReturnUrl() + "?reservationId=" + reservationId);
            params.put("vnp_IpAddr", "127.0.0.1");

            // Optional fields
            params.put("vnp_ExpireDate", VNPayConfig.getExpirationDate());

            // Create payment URL
            String paymentUrl = VNPayConfig.createPaymentUrl(params);

            logger.info("Created VNPay payment URL for reservation {} with amount {}", reservationId, amount);
            return paymentUrl;

        } catch (Exception e) {
            logger.error("Error creating VNPay payment URL for reservation {}", reservationId, e);
            return null;
        }
    }

    /**
     * Create simple payment URL (for testing)
     */
    public String createSimplePaymentUrl(long amount, String orderDescription) {
        try {
            Map<String, String> params = new HashMap<>();

            params.put("vnp_Amount", VNPayConfig.formatAmount(amount));
            params.put("vnp_OrderInfo", orderDescription);
            params.put("vnp_OrderType", "other");
            params.put("vnp_TxnRef", String.valueOf(System.currentTimeMillis()));
            params.put("vnp_ReturnUrl", VNPayConfig.getReturnUrl());
            params.put("vnp_IpAddr", "127.0.0.1");
            params.put("vnp_ExpireDate", VNPayConfig.getExpirationDate());

            return VNPayConfig.createPaymentUrl(params);

        } catch (Exception e) {
            logger.error("Error creating simple payment URL", e);
            return null;
        }
    }
}

