package com.fpt.restaurantbooking.utils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * VNPay Configuration and Utility Class
 * Handles payment URL generation and signature verification
 */
public class VNPayConfig {
    private static final Logger logger = LoggerFactory.getLogger(VNPayConfig.class);

    private static Properties vnpayProperties;
    private static final String VNPAY_CONFIG_FILE = "vnpay.properties";

    static {
        loadVNPayProperties();
    }

    /**
     * Load VNPay configuration properties
     */
    private static void loadVNPayProperties() {
        vnpayProperties = new Properties();
        try (var input = VNPayConfig.class.getClassLoader().getResourceAsStream(VNPAY_CONFIG_FILE)) {
            if (input != null) {
                vnpayProperties.load(input);
                logger.info("VNPay configuration loaded successfully");
            } else {
                logger.error("VNPay properties file not found");
            }
        } catch (Exception e) {
            logger.error("Error loading VNPay properties", e);
        }
    }

    /**
     * Get property value
     */
    public static String getProperty(String key) {
        return vnpayProperties.getProperty(key);
    }

    /**
     * Get merchant ID
     */
    public static String getMerchantId() {
        return getProperty("vnpay.merchant");
    }

    /**
     * Get access code
     */
    public static String getAccessCode() {
        return getProperty("vnpay.access.code");
    }

    /**
     * Get secret key
     */
    public static String getSecretKey() {
        return getProperty("vnpay.secret.key");
    }

    /**
     * Get VNPay URL
     */
    public static String getVNPayUrl() {
        return getProperty("vnpay.url");
    }

    /**
     * Get return URL
     */
    public static String getReturnUrl() {
        return getProperty("vnpay.return.url");
    }

    /**
     * Get IPN URL
     */
    public static String getIpnUrl() {
        return getProperty("vnpay.ipn.url");
    }

    /**
     * Create payment URL with parameters and signature
     */
    public static String createPaymentUrl(Map<String, String> params) {
        try {
            // Add required fields
            params.put("vnp_Version", getProperty("vnpay.version"));
            params.put("vnp_Command", getProperty("vnpay.command"));
            params.put("vnp_TmnCode", getMerchantId());
            params.put("vnp_CurrCode", getProperty("vnpay.currency"));
            params.put("vnp_Locale", getProperty("vnpay.locale"));

            // Add timestamp
            params.put("vnp_CreateDate", getTimestamp());

            // Encode all parameters
            String queryUrl = createQueryUrl(params);

            // Create secure hash
            String secureHash = createSecureHash(queryUrl);
            params.put("vnp_SecureHash", secureHash);

            // Build final URL
            queryUrl = createQueryUrl(params);
            String paymentUrl = getVNPayUrl() + "?" + queryUrl;

            logger.info("Created VNPay payment URL for amount: {}", params.get("vnp_Amount"));
            return paymentUrl;

        } catch (Exception e) {
            logger.error("Error creating VNPay payment URL", e);
            return null;
        }
    }

    /**
     * Create query string from parameters
     */
    private static String createQueryUrl(Map<String, String> params) throws UnsupportedEncodingException {
        // Sort parameters alphabetically
        TreeMap<String, String> sortedParams = new TreeMap<>(params);

        StringBuilder query = new StringBuilder();
        boolean first = true;

        for (Map.Entry<String, String> entry : sortedParams.entrySet()) {
            if (!first) {
                query.append("&");
            }
            query.append(URLEncoder.encode(entry.getKey(), StandardCharsets.UTF_8.toString()))
                    .append("=")
                    .append(URLEncoder.encode(entry.getValue(), StandardCharsets.UTF_8.toString()));
            first = false;
        }

        return query.toString();
    }

    /**
     * Create secure hash using HMAC SHA512
     */
    private static String createSecureHash(String data) throws Exception {
        String secretKey = getSecretKey();
        Mac hmacSha512 = Mac.getInstance("HmacSHA512");
        SecretKeySpec secretKeySpec = new SecretKeySpec(secretKey.getBytes(StandardCharsets.UTF_8), "HmacSHA512");
        hmacSha512.init(secretKeySpec);

        byte[] hashBytes = hmacSha512.doFinal(data.getBytes(StandardCharsets.UTF_8));

        // Convert to hex string
        StringBuilder hexString = new StringBuilder();
        for (byte b : hashBytes) {
            String hex = Integer.toHexString(0xff & b);
            if (hex.length() == 1) {
                hexString.append('0');
            }
            hexString.append(hex);
        }

        return hexString.toString();
    }

    /**
     * Verify return signature from VNPay
     */
    public static boolean verifySignature(Map<String, String> params) {
        try {
            String secureHash = params.get("vnp_SecureHash");
            if (secureHash == null || secureHash.isEmpty()) {
                logger.warn("Missing vnp_SecureHash in response");
                return false;
            }

            // Remove signature from params for verification
            Map<String, String> verifyParams = new TreeMap<>(params);
            verifyParams.remove("vnp_SecureHash");
            verifyParams.remove("vnp_SecureHashType");

            // Create query string
            String queryUrl = createQueryUrl(verifyParams);

            // Create expected hash
            String expectedHash = createSecureHash(queryUrl);

            // Compare
            boolean isValid = secureHash.equals(expectedHash);

            if (isValid) {
                logger.info("VNPay signature verification successful");
            } else {
                logger.error("VNPay signature verification failed");
                logger.error("Expected: {}, Received: {}", expectedHash, secureHash);
            }

            return isValid;

        } catch (Exception e) {
            logger.error("Error verifying VNPay signature", e);
            return false;
        }
    }

    /**
     * Get current timestamp in VNPay format (yyyyMMddHHmmss)
     */
    public static String getTimestamp() {
        Calendar cal = Calendar.getInstance();
        int year = cal.get(Calendar.YEAR);
        int month = cal.get(Calendar.MONTH) + 1;
        int day = cal.get(Calendar.DAY_OF_MONTH);
        int hour = cal.get(Calendar.HOUR_OF_DAY);
        int minute = cal.get(Calendar.MINUTE);
        int second = cal.get(Calendar.SECOND);

        return String.format("%d%02d%02d%02d%02d%02d", year, month, day, hour, minute, second);
    }

    /**
     * Get expiration date (default 15 minutes from now)
     */
    public static String getExpirationDate() {
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MINUTE, 15);

        int year = cal.get(Calendar.YEAR);
        int month = cal.get(Calendar.MONTH) + 1;
        int day = cal.get(Calendar.DAY_OF_MONTH);
        int hour = cal.get(Calendar.HOUR_OF_DAY);
        int minute = cal.get(Calendar.MINUTE);
        int second = cal.get(Calendar.SECOND);

        return String.format("%d%02d%02d%02d%02d%02d", year, month, day, hour, minute, second);
    }

    /**
     * Format amount for VNPay (remove decimal, multiply by 100)
     */
    public static String formatAmount(long amount) {
        return String.valueOf(amount * 100);
    }
}

