package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.repositories.impl.ReservationDAO;
import com.fpt.restaurantbooking.repositories.impl.TableDAO;
import com.fpt.restaurantbooking.models.Table;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class TableService {

    private final TableDAO tableDAO;
    private final ReservationDAO reservationDAO;

    public TableService() {
        this.tableDAO = new TableDAO();
        this.reservationDAO = new ReservationDAO();
    }

    /**
     * Finds available tables based on the given criteria.
     *
     * @param requiredDate The reservation date.
     * @param requiredTime The reservation time.
     * @param guestCount   The number of guests.
     * @return A map of table ID to a Map containing table details and status.
     */
    public Map<Integer, Map<String, Object>> findAvailableTables(LocalDate requiredDate, LocalTime requiredTime, int guestCount) {
        List<Table> allTables = tableDAO.getAllTables();
        List<Table> availableTables = new ArrayList<>();
        List<Table> bookedTables = new ArrayList<>();

        for (Table table : allTables) {
            boolean isBooked = reservationDAO.isTableReserved(table.getTableId(), requiredDate, requiredTime);
            if (isBooked) {
                bookedTables.add(table);
            } else {
                availableTables.add(table);
            }
        }

        // Combine and format the results for JSP
        return allTables.stream().collect(Collectors.toMap(
                Table::getTableId,
                table -> {
                    boolean isBooked = bookedTables.contains(table);
                    Map<String, Object> details = new java.util.HashMap<>();
                    details.put("capacity", table.getCapacity());
                    details.put("floor", table.getFloor());
                    details.put("status", isBooked ? "booked" : "available");
                    details.put("match", !isBooked && table.getCapacity() >= guestCount);
                    return details;
                }
        ));
    }
}