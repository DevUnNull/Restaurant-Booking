<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="Shopping Cart - Tica's Tacos" />
<c:set var="pageDescription" value="Review your selected items and proceed to checkout" />
<c:set var="pageCSS" value="cart.css" />
<c:set var="pageJS" value="cart.js" />

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
        <div class="cart-container">
            <h1>Shopping Cart</h1>
            
            <!-- Cart Items Container -->
            <div id="cart-items" class="cart-items">
                <c:choose>
                    <c:when test="${not empty cartItems}">
                        <c:forEach var="item" items="${cartItems}" varStatus="status">
                            <div class="cart-item" data-item-id="${item.itemId}">
                                <img src="${pageContext.request.contextPath}/assets/images/menu/${item.imageUrl}" 
                                     alt="${item.itemName}" class="item-image">
                                <div class="item-details">
                                    <h3 class="item-name">${item.itemName}</h3>
                                    <p class="item-description">${item.description}</p>
                                </div>
                                <div class="item-quantity">
                                    <button type="button" class="quantity-btn decrease" onclick="updateQuantity(${status.index}, -1)">-</button>
                                    <span class="quantity">${item.quantity}</span>
                                    <button type="button" class="quantity-btn increase" onclick="updateQuantity(${status.index}, 1)">+</button>
                                </div>
                                <div class="item-price">
                                    <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="₫" />
                                </div>
                                <button type="button" class="remove-btn" onclick="removeItem(${status.index})">
                                    Remove
                                </button>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="empty-cart">
                            <p>Your shopping cart is empty.</p>
                            <a href="${pageContext.request.contextPath}/menu" class="btn btn-primary">Browse Menu</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
            
            <!-- Cart Summary -->
            <div class="cart-summary">
                <div class="total-section">
                    <div class="subtotal">
                        <span>Subtotal:</span>
                        <span id="subtotal-price">
                            <c:choose>
                                <c:when test="${not empty cartTotal}">
                                    <fmt:formatNumber value="${cartTotal}" type="currency" currencySymbol="₫" />
                                </c:when>
                                <c:otherwise>0 ₫</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="tax">
                        <span>Tax (10%):</span>
                        <span id="tax-price">
                            <c:choose>
                                <c:when test="${not empty cartTotal}">
                                    <fmt:formatNumber value="${cartTotal * 0.1}" type="currency" currencySymbol="₫" />
                                </c:when>
                                <c:otherwise>0 ₫</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="total">
                        <span>Total:</span>
                        <span id="total-price">
                            <c:choose>
                                <c:when test="${not empty cartTotal}">
                                    <fmt:formatNumber value="${cartTotal * 1.1}" type="currency" currencySymbol="₫" />
                                </c:when>
                                <c:otherwise>0 ₫</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>
            
            <!-- Cart Actions -->
            <div class="cart-actions">
                <a href="${pageContext.request.contextPath}/menu" class="btn btn-secondary">
                    Continue Shopping
                </a>
                <button type="button" class="btn btn-warning" onclick="clearCart()">
                    Clear Cart
                </button>
                <c:choose>
                    <c:when test="${not empty cartItems}">
                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary">
                            Proceed to Checkout
                        </a>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn btn-primary" disabled>
                            Proceed to Checkout
                        </button>
                    </c:otherwise>
                </c:choose>
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

    <!-- Cart Data for JavaScript -->
    <script>
        // Pass server-side data to client-side JavaScript
        window.cartData = {
            items: [
                <c:forEach var="item" items="${cartItems}" varStatus="status">
                    {
                        id: ${item.itemId},
                        name: "${item.itemName}",
                        price: ${item.price},
                        quantity: ${item.quantity},
                        image: "${item.imageUrl}",
                        description: "${item.description}"
                    }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            ],
            total: ${not empty cartTotal ? cartTotal : 0},
            contextPath: "${pageContext.request.contextPath}"
        };
    </script>

    <!-- Toast Handler -->
    <jsp:include page="../common/toast-handler.jsp" />
</body>
</html>