package com.example;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class AppTest {

    @Test
    public void testGetGreeting() {
        assertEquals("Hello, World!", App.getGreeting());
    }
}