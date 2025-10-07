package com.fpt.restaurantbooking.utils;

import com.google.gson.*;

import java.lang.reflect.Type;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

/**
 * Gson adapter for LocalTime serialization and deserialization
 */
public class LocalTimeAdapter implements JsonSerializer<LocalTime>, JsonDeserializer<LocalTime> {
    
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("HH:mm:ss");
    
    @Override
    public JsonElement serialize(LocalTime localTime, Type type, JsonSerializationContext context) {
        return new JsonPrimitive(localTime.format(FORMATTER));
    }
    
    @Override
    public LocalTime deserialize(JsonElement jsonElement, Type type, JsonDeserializationContext context) 
            throws JsonParseException {
        try {
            return LocalTime.parse(jsonElement.getAsString(), FORMATTER);
        } catch (DateTimeParseException e) {
            throw new JsonParseException("Unable to parse LocalTime: " + jsonElement.getAsString(), e);
        }
    }
}