package com.fpt.restaurantbooking.utils;

import com.google.gson.*;

import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

/**
 * Gson adapter for LocalDateTime serialization and deserialization
 */
public class LocalDateTimeAdapter implements JsonSerializer<LocalDateTime>, JsonDeserializer<LocalDateTime> {
    
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    @Override
    public JsonElement serialize(LocalDateTime localDateTime, Type type, JsonSerializationContext context) {
        return new JsonPrimitive(localDateTime.format(FORMATTER));
    }
    
    @Override
    public LocalDateTime deserialize(JsonElement jsonElement, Type type, JsonDeserializationContext context) 
            throws JsonParseException {
        try {
            return LocalDateTime.parse(jsonElement.getAsString(), FORMATTER);
        } catch (DateTimeParseException e) {
            throw new JsonParseException("Unable to parse LocalDateTime: " + jsonElement.getAsString(), e);
        }
    }
}