package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.utils.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalTime;

public class ReservationDAO {

    private static final Logger logger = LoggerFactory.getLogger(ReservationDAO.class);

    /**
     * Checks if a table is reserved at a specific date and time.
     *
     * @param tableId The ID of the table to check.
     * @param date    The reservation date.
     * @param time    The reservation time.
     * @return true if the table is reserved, false otherwise.
     */
    public boolean isTableReserved(int tableId, LocalDate date, LocalTime time) {
        // Assume a reservation slot is 2 hours
        LocalTime endTime = time.plusHours(2);

        // SQL to check for overlapping reservations
        String sql = "SELECT COUNT(*) FROM Reservations " +
                "WHERE table_id = ? AND reservation_date = ? " +
                "AND (reservation_time BETWEEN ? AND ? OR ? BETWEEN reservation_time AND ?)";

        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql)) {

            preparedStatement.setInt(1, tableId);
            preparedStatement.setDate(2, java.sql.Date.valueOf(date));
            preparedStatement.setTime(3, java.sql.Time.valueOf(time));
            preparedStatement.setTime(4, java.sql.Time.valueOf(endTime));
            preparedStatement.setTime(5, java.sql.Time.valueOf(time));
            preparedStatement.setTime(6, java.sql.Time.valueOf(endTime));

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    return resultSet.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            logger.error("Error checking table reservation status for tableId: " + tableId, e);
        }
        return false;
    }
}