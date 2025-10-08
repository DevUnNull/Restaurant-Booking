package com.fpt.restaurantbooking.services.impl;

import com.fpt.restaurantbooking.models.Reservation;
import com.fpt.restaurantbooking.repositories.ReservationRepository;
import com.fpt.restaurantbooking.services.DashboardService;
import com.google.gson.Gson;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

public class DashboardServiceImpl implements DashboardService {

    // Hằng số được định nghĩa để tránh trùng lặp literal
    private static final String STATUS_CONFIRMED = "CONFIRMED";
    private static final String STATUS_CANCELLED = "CANCELLED";

    // Dùng chung một instance Random cho toàn class
    private static final Random RANDOM = new Random();

    private final ReservationRepository reservationRepository;
    private final Gson gson = new Gson();

    public DashboardServiceImpl() {
        // Repository giả lập dữ liệu demo
        this.reservationRepository = new ReservationRepository() {
            @Override
            public List<Reservation> findByUserId(Long userId) {
                return List.of();
            }

            @Override
            public List<Reservation> findByRestaurantId(Long restaurantId) {
                return List.of();
            }

            @Override
            public List<Reservation> findByTableId(Long tableId) {
                return List.of();
            }

            @Override
            public List<Reservation> findByStatus(Reservation.ReservationStatus status) {
                return List.of();
            }

            @Override
            public List<Reservation> findByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
                return List.of();
            }

            @Override
            public List<Reservation> findByRestaurantAndDateRange(Long restaurantId, LocalDateTime startDate, LocalDateTime endDate) {
                return List.of();
            }

            @Override
            public List<Reservation> findByTableAndDateRange(Long tableId, LocalDateTime startDate, LocalDateTime endDate) {
                return List.of();
            }

            @Override
            public List<Reservation> findUpcomingReservationsByUserId(Long userId) {
                return List.of();
            }

            @Override
            public List<Reservation> findPastReservationsByUserId(Long userId) {
                return List.of();
            }

            @Override
            public List<Reservation> findTodayReservationsByRestaurant(Long restaurantId) {
                return List.of();
            }

            @Override
            public boolean isTableAvailable(Long tableId, LocalDateTime startTime, LocalDateTime endTime) {
                return false;
            }

            @Override
            public boolean updateStatus(Long reservationId, Reservation.ReservationStatus status) {
                return false;
            }

            @Override
            public Map<String, Object> getOverviewStats() {
                return Map.of();
            }

            @Override
            public Reservation save(Reservation entity) {
                return null;
            }

            @Override
            public Reservation update(Reservation entity) {
                return null;
            }

            @Override
            public Optional<Reservation> findById(Long aLong) {
                return Optional.empty();
            }

            @Override
            public List<Reservation> findAll() {
                // Dữ liệu demo với trạng thái CONFIRMED và CANCELLED
                return List.of(
                        new Reservation(1, 1, 1, 4, LocalDate.now().minusDays(2).atTime(18, 0), STATUS_CONFIRMED, 500000),
                        new Reservation(2, 1, 2, 2, LocalDate.now().minusDays(1).atTime(19, 0), STATUS_CONFIRMED, 700000),
                        new Reservation(3, 1, 3, 3, LocalDate.now().atTime(20, 0), STATUS_CANCELLED, 0)
                );
            }

            @Override
            public List<Reservation> findAllActive() {
                return List.of();
            }

            @Override
            public boolean deleteById(Long aLong) {
                return false;
            }

            @Override
            public boolean softDeleteById(Long aLong) {
                return false;
            }

            @Override
            public boolean existsById(Long aLong) {
                return false;
            }

            @Override
            public long count() {
                return 0;
            }

            @Override
            public long countActive() {
                return 0;
            }
        };
    }

    // Hàm thống kê tổng quan Dashboard
    @Override
    public Map<String, Object> getOverviewStats() {
        List<Reservation> reservations = reservationRepository.findAll();

        long totalReservations = reservations.size();
        long totalCanceled = reservations.stream()
                .filter(r -> STATUS_CANCELLED.equalsIgnoreCase(r.getStatus()))
                .count();
        long totalRevenue = reservations.stream()
                .filter(r -> STATUS_CONFIRMED.equalsIgnoreCase(r.getStatus()))
                .mapToLong(r -> r.getTotalAmount() != null ? r.getTotalAmount().longValue() : 0L)
                .sum();

        return Map.of(
                "totalReservations", totalReservations,
                "totalRevenue", totalRevenue,
                "totalCanceled", totalCanceled
        );
    }

    // Hàm tạo dữ liệu biểu đồ doanh thu 7 ngày gần nhất
    @Override
    public String getDailyRevenueForChart() {
        LocalDate today = LocalDate.now();
        List<String> labels = new ArrayList<>();
        List<Long> values = new ArrayList<>();

        for (int i = 6; i >= 0; i--) {
            LocalDate date = today.minusDays(i);
            labels.add(date.format(DateTimeFormatter.ofPattern("dd/MM")));
            values.add(300000L + RANDOM.nextInt(1000000)); // doanh thu giả
        }

        Map<String, Object> chartData = Map.of(
                "labels", labels,
                "values", values
        );

        return gson.toJson(chartData);
    }
}
