package com.fpt.restaurantbooking.services;

import java.util.Map;

/**
 * Service interface for Dashboard business operations.
 * Defines the contract for fetching data required by the admin dashboard.
 */
public interface DashboardService {

    /**
     * Gets overview statistics like total revenue, total bookings, etc.
     * @return A map containing key-value pairs of the statistics.
     */
    Map<String, Object> getOverviewStats();

    /**
     * Gets data formatted for a daily revenue chart.
     * @return A JSON string representing the chart data.
     */
    String getDailyRevenueForChart();
}