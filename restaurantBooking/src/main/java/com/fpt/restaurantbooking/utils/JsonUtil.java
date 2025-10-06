package com.fpt.restaurantbooking.utils;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.Map;

/**
 * JSON utility class for serialization and deserialization using Gson
 */
public class JsonUtil {
    
    private static final Logger logger = LoggerFactory.getLogger(JsonUtil.class);
    private static final Gson gson;
    
    static {
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .registerTypeAdapter(LocalTime.class, new LocalTimeAdapter())
                .setDateFormat("yyyy-MM-dd HH:mm:ss")
                .setPrettyPrinting()
                .create();
    }
    
    /**
     * Convert object to JSON string
     */
    public static String toJson(Object object) {
        try {
            return gson.toJson(object);
        } catch (Exception e) {
            logger.error("Error converting object to JSON", e);
            return null;
        }
    }
    
    /**
     * Convert JSON string to object
     */
    public static <T> T fromJson(String json, Class<T> classOfT) {
        try {
            return gson.fromJson(json, classOfT);
        } catch (JsonSyntaxException e) {
            logger.error("Error parsing JSON to object", e);
            return null;
        }
    }
    
    /**
     * Convert JSON string to object with Type
     */
    public static <T> T fromJson(String json, Type typeOfT) {
        try {
            return gson.fromJson(json, typeOfT);
        } catch (JsonSyntaxException e) {
            logger.error("Error parsing JSON to object with Type", e);
            return null;
        }
    }
    
    /**
     * Convert JSON string to List
     */
    public static <T> List<T> fromJsonToList(String json, Class<T> classOfT) {
        try {
            Type listType = TypeToken.getParameterized(List.class, classOfT).getType();
            return gson.fromJson(json, listType);
        } catch (JsonSyntaxException e) {
            logger.error("Error parsing JSON to List", e);
            return null;
        }
    }
    
    /**
     * Convert JSON string to Map
     */
    public static Map<String, Object> fromJsonToMap(String json) {
        try {
            Type mapType = new TypeToken<Map<String, Object>>(){}.getType();
            return gson.fromJson(json, mapType);
        } catch (JsonSyntaxException e) {
            logger.error("Error parsing JSON to Map", e);
            return null;
        }
    }
    
    /**
     * Check if string is valid JSON
     */
    public static boolean isValidJson(String json) {
        if (json == null || json.trim().isEmpty()) {
            return false;
        }
        
        try {
            gson.fromJson(json, Object.class);
            return true;
        } catch (JsonSyntaxException e) {
            return false;
        }
    }
    
    /**
     * Pretty print JSON string
     */
    public static String prettyPrint(String json) {
        try {
            Object obj = gson.fromJson(json, Object.class);
            return gson.toJson(obj);
        } catch (JsonSyntaxException e) {
            logger.error("Error pretty printing JSON", e);
            return json;
        }
    }
    
    /**
     * Convert object to JSON string without pretty printing
     */
    public static String toJsonCompact(Object object) {
        try {
            Gson compactGson = new GsonBuilder()
                    .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                    .registerTypeAdapter(LocalTime.class, new LocalTimeAdapter())
                    .setDateFormat("yyyy-MM-dd HH:mm:ss")
                    .create();
            return compactGson.toJson(object);
        } catch (Exception e) {
            logger.error("Error converting object to compact JSON", e);
            return null;
        }
    }
    
    /**
     * Deep clone object using JSON serialization
     */
    public static <T> T deepClone(T object, Class<T> classOfT) {
        try {
            String json = toJson(object);
            return fromJson(json, classOfT);
        } catch (Exception e) {
            logger.error("Error deep cloning object", e);
            return null;
        }
    }
    
    /**
     * Merge two JSON objects
     */
    public static String mergeJson(String json1, String json2) {
        try {
            Map<String, Object> map1 = fromJsonToMap(json1);
            Map<String, Object> map2 = fromJsonToMap(json2);
            
            if (map1 == null) map1 = Map.of();
            if (map2 == null) map2 = Map.of();
            
            map1.putAll(map2);
            return toJson(map1);
        } catch (Exception e) {
            logger.error("Error merging JSON objects", e);
            return null;
        }
    }
    
    /**
     * Extract value from JSON by key path (e.g., "user.profile.name")
     */
    @SuppressWarnings("unchecked")
    public static Object extractValue(String json, String keyPath) {
        try {
            Map<String, Object> map = fromJsonToMap(json);
            if (map == null) return null;
            
            String[] keys = keyPath.split("\\.");
            Object current = map;
            
            for (String key : keys) {
                if (current instanceof Map) {
                    current = ((Map<String, Object>) current).get(key);
                } else {
                    return null;
                }
            }
            
            return current;
        } catch (Exception e) {
            logger.error("Error extracting value from JSON", e);
            return null;
        }
    }
    
    /**
     * Get Gson instance for custom usage
     */
    public static Gson getGson() {
        return gson;
    }
}