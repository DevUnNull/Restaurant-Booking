package com.fpt.restaurantbooking.repositories.impl;

import com.fpt.restaurantbooking.models.Table;
import com.fpt.restaurantbooking.utils.DatabaseUtil;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class TableDAO {

    private static final Logger logger = LoggerFactory.getLogger(TableDAO.class);

    /**
     * Retrieves all tables from the database.
     *
     * @return A list of all tables.
     */
    public List<Table> getAllTables() {
        List<Table> tables = new ArrayList<>();
        String sql = "SELECT table_id, table_name, capacity, floor, table_type, status FROM Tables";
        try (Connection connection = DatabaseUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(sql);
             ResultSet resultSet = preparedStatement.executeQuery()) {

            while (resultSet.next()) {
                Table table = new Table();
                table.setTableId(resultSet.getInt("table_id"));
                table.setTableName(resultSet.getString("table_name"));
                table.setCapacity(resultSet.getInt("capacity"));
                table.setFloor(resultSet.getInt("floor"));
                table.setTableType(resultSet.getString("table_type"));
                table.setStatus(resultSet.getString("status"));
                tables.add(table);
            }
        } catch (SQLException e) {
            logger.error("Error retrieving all tables", e);
        }
        return tables;
    }
}