package com.fpt.restaurantbooking.services;

import com.fpt.restaurantbooking.repositories.EmailVerificationRepository;
import com.fpt.restaurantbooking.repositories.UserRepository;
import com.fpt.restaurantbooking.repositories.impl.EmailVerificationRepositoryImpl;
import com.fpt.restaurantbooking.repositories.impl.UserRepositoryImpl;
import com.fpt.restaurantbooking.services.impl.UserServiceImpl;
import com.fpt.restaurantbooking.utils.DatabaseUtil;

import java.sql.SQLException;

public class OTPServiceTest {
    public static void main(String[] args) throws SQLException {
        var connection = DatabaseUtil.getConnection();
        UserRepository userRepository = new UserRepositoryImpl(connection);
        EmailVerificationRepository emailVerificationRepository = new EmailVerificationRepositoryImpl(DatabaseUtil.getConnection());
        OTPService otpService = new OTPService(emailVerificationRepository);

        EmailService emailService = new EmailService();
        UserServiceImpl  UserServiceImpl = new UserServiceImpl(userRepository,emailVerificationRepository, otpService, emailService);

        otpService.generateOTPForUser(43L);
        UserServiceImpl.sendOTPVerificationEmail(43L);
    }
}
