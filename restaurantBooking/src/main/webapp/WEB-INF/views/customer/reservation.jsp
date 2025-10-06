<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<c:set var="pageTitle" value="Table Reservation" />
<c:set var="pageDescription" value="Reserve your table with our interactive 3D restaurant layout" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle} - Tica's Tacos</title>
    <meta name="description" content="${pageDescription}">
    
    <!-- Common CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/reservation.css">
    
    <!-- Three.js Libraries -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r134/three.min.js"></script>
    <script src="https://unpkg.com/three@0.134.0/examples/js/controls/OrbitControls.js"></script>
    <script src="https://unpkg.com/three@0.134.0/examples/js/loaders/GLTFLoader.js"></script>
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../common/header.jsp" />
    
    <!-- Main Content -->
    <main class="reservation-page">
        <!-- Page Header -->
        <section class="page-header">
            <div class="container">
                <h1>Table Reservation</h1>
                <p>Select your preferred table using our interactive 3D restaurant layout</p>
            </div>
        </section>
        
        <!-- 3D Restaurant Layout -->
        <section class="restaurant-3d">
            <div class="container">
                <div id="canvas-container" class="canvas-wrapper">
                    <div class="loading-indicator" id="loadingIndicator">
                        <div class="spinner"></div>
                        <p>Loading restaurant layout...</p>
                    </div>
                </div>
                
                <!-- 3D Controls Info -->
                <div class="controls-info">
                    <h3>Navigation Controls</h3>
                    <ul>
                        <li><strong>Rotate:</strong> Left click and drag</li>
                        <li><strong>Zoom:</strong> Mouse wheel or right click and drag</li>
                        <li><strong>Pan:</strong> Middle click and drag</li>
                    </ul>
                </div>
            </div>
        </section>
        
        <!-- Reservation Form -->
        <section class="reservation-form-section">
            <div class="container">
                <div class="form-wrapper">
                    <h2>Make Your Reservation</h2>
                    
                    <form id="reservationForm" class="reservation-form" action="${pageContext.request.contextPath}/reservation/submit" method="post">
                        <div class="form-group">
                            <label for="customerName">Full Name *</label>
                            <input type="text" id="customerName" name="customerName" required 
                                   placeholder="Enter your full name">
                        </div>
                        
                        <div class="form-group">
                            <label for="customerPhone">Phone Number *</label>
                            <input type="tel" id="customerPhone" name="customerPhone" required 
                                   placeholder="Enter your phone number">
                        </div>
                        
                        <div class="form-group">
                            <label for="customerEmail">Email Address</label>
                            <input type="email" id="customerEmail" name="customerEmail" 
                                   placeholder="Enter your email address">
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="reservationDate">Date *</label>
                                <input type="date" id="reservationDate" name="reservationDate" required>
                            </div>
                            
                            <div class="form-group">
                                <label for="reservationTime">Time *</label>
                                <input type="time" id="reservationTime" name="reservationTime" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="guestCount">Number of Guests *</label>
                                <select id="guestCount" name="guestCount" required>
                                    <option value="">Select guests</option>
                                    <c:forEach var="i" begin="1" end="12">
                                        <option value="${i}">${i} ${i == 1 ? 'Guest' : 'Guests'}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label for="tableCode">Table Number *</label>
                                <input type="number" id="tableCode" name="tableCode" required 
                                       placeholder="Select table from 3D view" min="1">
                                <small class="form-help">Available tables: 1, 4, 7, 10, 13, 16, 19, 22, 25</small>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="specialRequests">Special Requests</label>
                            <textarea id="specialRequests" name="specialRequests" rows="3" 
                                      placeholder="Any special dietary requirements, celebrations, or other requests..."></textarea>
                        </div>
                        
                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="resetForm()">Reset Form</button>
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <span class="btn-text">Reserve Table</span>
                                <span class="btn-loading" style="display: none;">
                                    <span class="spinner-small"></span> Processing...
                                </span>
                            </button>
                        </div>
                        
                        <!-- Status Messages -->
                        <div id="formStatus" class="form-status"></div>
                    </form>
                    
                    <!-- Available Tables Info -->
                    <div class="table-info">
                        <h3>Table Information</h3>
                        <div class="table-legend">
                            <div class="legend-item">
                                <span class="legend-color available"></span>
                                <span>Available</span>
                            </div>
                            <div class="legend-item">
                                <span class="legend-color selected"></span>
                                <span>Selected</span>
                            </div>
                            <div class="legend-item">
                                <span class="legend-color booked"></span>
                                <span>Already Booked</span>
                            </div>
                        </div>
                        
                        <!-- Dynamic table availability (if available from server) -->
                        <c:if test="${not empty availableTables}">
                            <div class="available-tables">
                                <h4>Currently Available Tables:</h4>
                                <div class="table-list">
                                    <c:forEach var="table" items="${availableTables}">
                                        <span class="table-badge" onclick="selectTableFromList(${table.tableNumber})">
                                            Table ${table.tableNumber} (${table.capacity} seats)
                                        </span>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </section>
    </main>
    
    <!-- Include Footer -->
    <jsp:include page="../common/footer.jsp" />
    
    <!-- Hidden data for JavaScript -->
    <script type="application/json" id="reservationData">
        {
            "validTableCodes": [1, 4, 7, 10, 13, 16, 19, 22, 25],
            "bookedTables": ${not empty bookedTables ? bookedTables : '[]'},
            "minDate": "${minReservationDate}",
            "maxDate": "${maxReservationDate}",
            "availableTimeSlots": ${not empty timeSlots ? timeSlots : '["11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30"]'}
        }
    </script>
    
    <!-- Common JavaScript -->
    <script src="${pageContext.request.contextPath}/js/reservation.js"></script>
</body>
</html>