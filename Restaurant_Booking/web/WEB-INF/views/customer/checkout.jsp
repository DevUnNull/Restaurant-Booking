<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Checkout - Tica's Tacos" />
<c:set var="pageDescription" value="Complete your order and payment" />
<c:set var="pageCSS" value="checkout.css" />
<c:set var="pageJS" value="checkout.js" />

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle}</title>
    <meta name="description" content="${pageDescription}">
    
    <!-- Common CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common.css">
    
    <!-- Page-specific CSS -->
    <c:if test="${not empty pageCSS}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/${pageCSS}">
    </c:if>
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Roboto:wght@400;700&display=swap" rel="stylesheet">
</head>
<body>
    <!-- Include Header -->
    <jsp:include page="../common/header.jsp" />

    <main class="main-content">
        <div class="checkout-container">
            <div class="checkout-grid">
                <!-- Payment Section -->
                <div class="payment-section">
                    <h2 class="section-title">Payment Method</h2>
                    
                    <div class="payment-methods">
                        <div class="payment-method active" data-tab="online-banking">
                            <img src="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTL9Cpp1nDLbzIrK_-ljQsqJOGbytIiiDAgmQ&s" alt="Banking">
                            <div>Online Banking</div>
                        </div>
                        <div class="payment-method" data-tab="credit-card">
                            <img src="https://www.visa.com.vn/dam/VCOM/regional/ap/vietnam/global-elements/images/vn-visa-platinum-card-498x280.png" alt="Card">
                            <div>Credit Card</div>
                        </div>
                    </div>

                    <div class="payment-tabs">
                        <!-- Online Banking Tab -->
                        <div class="tab-content active" id="online-banking">
                            <div class="qr-section">
                                <h3>Scan QR Code to Pay</h3>
                                <div class="qr-methods">
                                    <div class="qr-container">
                                        <img src="${pageContext.request.contextPath}/assets/images/banner/vietinbank.jpeg" alt="VietinBank QR Code">
                                        <p>VietinBank</p>
                                    </div>
                                    <div class="qr-container">
                                        <img src="${pageContext.request.contextPath}/assets/images/banner/momo.jpeg" alt="MoMo QR Code">
                                        <p>MoMo</p>
                                    </div>
                                </div>
                            </div>

                            <div class="bank-instructions">
                                <h3>Payment Instructions</h3>
                                <ol>
                                    <li>Open your banking or MoMo app and scan the QR code.</li>
                                    <li>Enter exact amount: <strong id="total-to-pay">0 ₫</strong></li>
                                    <li>Transfer content: <strong>ORDER_<span id="order-code">${orderCode}</span></strong></li>
                                    <li>Confirm and complete payment.</li>
                                </ol>
                            </div>
                        </div>

                        <!-- Credit Card Tab -->
                        <div class="tab-content" id="credit-card">
                            <form id="card-form">
                                <div class="form-group">
                                    <label for="card-number">Card Number</label>
                                    <input type="text" class="form-control" id="card-number" 
                                           placeholder="1234 5678 9012 3456" maxlength="19">
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="expiry-date">Expiration Date</label>
                                        <input type="text" class="form-control" id="expiry-date" 
                                               placeholder="MM/YY" maxlength="5">
                                    </div>
                                    <div class="form-group">
                                        <label for="cvv">CVV</label>
                                        <input type="text" class="form-control" id="cvv" 
                                               placeholder="123" maxlength="4">
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="card-holder">Cardholder Name</label>
                                    <input type="text" class="form-control" id="card-holder" 
                                           placeholder="John Doe">
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Delivery Information -->
                    <form id="delivery-form" action="${pageContext.request.contextPath}/checkout/process" method="post">
                        <h3 class="section-title">Delivery Information</h3>
                        
                        <div class="form-group">
                            <label for="customer-name">Full Name *</label>
                            <input type="text" class="form-control" id="customer-name" name="customerName" 
                                   value="${customer.fullName}" placeholder="Enter your full name" required>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label for="customer-phone">Phone Number *</label>
                                <input type="tel" class="form-control" id="customer-phone" name="customerPhone" 
                                       value="${customer.phoneNumber}" placeholder="Enter phone number" required>
                            </div>
                            <div class="form-group">
                                <label for="customer-email">Email *</label>
                                <input type="email" class="form-control" id="customer-email" name="customerEmail" 
                                       value="${customer.email}" placeholder="Enter email" required>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label for="delivery-address">Delivery Address *</label>
                            <input type="text" class="form-control" id="delivery-address" name="deliveryAddress" 
                                   placeholder="Enter delivery address" required>
                            <small class="form-text">Distance: <span id="distance">-- km</span> | 
                                   Shipping fee: <span id="shipping-fee">0 ₫</span></small>
                        </div>
                        
                        <div class="form-group">
                            <label for="delivery-notes">Delivery Notes</label>
                            <textarea class="form-control" id="delivery-notes" name="deliveryNotes" 
                                      rows="3" placeholder="Special instructions for delivery (optional)"></textarea>
                        </div>
                        
                        <!-- Hidden fields for order data -->
                        <input type="hidden" name="orderItems" id="order-items-data">
                        <input type="hidden" name="subtotal" id="subtotal-data">
                        <input type="hidden" name="shippingFee" id="shipping-fee-data" value="0">
                        <input type="hidden" name="total" id="total-data">
                        <input type="hidden" name="paymentMethod" id="payment-method-data" value="online-banking">
                    </form>
                </div>

                <!-- Order Summary Section -->
                <div class="summary-section">
                    <h2 class="section-title">Order Summary</h2>
                    
                    <div id="order-summary" class="order-items">
                        <c:choose>
                            <c:when test="${not empty orderItems}">
                                <c:forEach var="item" items="${orderItems}">
                                    <div class="order-item">
                                        <div class="item-info">
                                            <div class="item-image">
                                                <img src="${pageContext.request.contextPath}/assets/images/menu/${item.imageUrl}" 
                                                     alt="${item.itemName}">
                                            </div>
                                            <div class="item-details">
                                                <div class="item-name">${item.itemName}</div>
                                                <div class="item-quantity">Qty: ${item.quantity}</div>
                                            </div>
                                        </div>
                                        <div class="item-price">
                                            <fmt:formatNumber value="${item.price * item.quantity}" type="currency" currencySymbol="₫" />
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-order">
                                    <p>No items in your order.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="order-totals">
                        <div class="subtotal-row">
                            <span>Subtotal:</span>
                            <span id="subtotal">
                                <c:choose>
                                    <c:when test="${not empty orderTotal}">
                                        <fmt:formatNumber value="${orderTotal}" type="currency" currencySymbol="₫" />
                                    </c:when>
                                    <c:otherwise>0 ₫</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="shipping-row">
                            <span>Shipping:</span>
                            <span id="shipping">0 ₫</span>
                        </div>
                        <div class="tax-row">
                            <span>Tax (10%):</span>
                            <span id="tax">
                                <c:choose>
                                    <c:when test="${not empty orderTotal}">
                                        <fmt:formatNumber value="${orderTotal * 0.1}" type="currency" currencySymbol="₫" />
                                    </c:when>
                                    <c:otherwise>0 ₫</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                        <div class="total-row">
                            <span>Total:</span>
                            <span id="total">
                                <c:choose>
                                    <c:when test="${not empty orderTotal}">
                                        <fmt:formatNumber value="${orderTotal * 1.1}" type="currency" currencySymbol="₫" />
                                    </c:when>
                                    <c:otherwise>0 ₫</c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    
                    <button type="button" class="btn btn-primary btn-place-order" onclick="placeOrder()">
                        Place Order
                    </button>
                </div>
            </div>
        </div>
    </main>

    <!-- Include Footer -->
    <jsp:include page="../common/footer.jsp" />

    <!-- Common JavaScript -->
    <script src="${pageContext.request.contextPath}/js/common.js"></script>
    
    <!-- Page-specific JavaScript -->
    <c:if test="${not empty pageJS}">
        <script src="${pageContext.request.contextPath}/js/${pageJS}"></script>
    </c:if>

    <!-- Checkout Data for JavaScript -->
    <script>
        // Pass server-side data to client-side JavaScript
        window.checkoutData = {
            orderItems: [
                <c:forEach var="item" items="${orderItems}" varStatus="status">
                    {
                        id: ${item.itemId},
                        name: "${item.itemName}",
                        price: ${item.price},
                        quantity: ${item.quantity},
                        image: "${item.imageUrl}"
                    }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ],
            subtotal: ${not empty orderTotal ? orderTotal : 0},
            orderCode: "${orderCode}",
            contextPath: "${pageContext.request.contextPath}",
            restaurantLocation: {
                lat: 21.03578588599425,
                lng: 105.83841731540213
            }
        };
    </script>
    
    <!-- Toast Handler -->
    <jsp:include page="../common/toast-handler.jsp" />
</body>
</html>