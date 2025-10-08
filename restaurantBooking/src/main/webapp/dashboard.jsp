<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Thống kê nhà hàng</title>

    <!-- AdminLTE -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/adminlte/bootstrap/css/bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/adminlte/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/adminlte/dist/css/skins/_all-skins.min.css">

    <!-- Chart.js -->
    <script src="${pageContext.request.contextPath}/adminlte/plugins/chartjs/Chart.js"></script>
</head>

<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

    <%@ include file="sidebar.jsp" %>

    <div class="content-wrapper">
        <section class="content-header">
            <h1>Bảng điều khiển <small>Thống kê doanh thu & lịch đặt</small></h1>
        </section>

        <section class="content">
            <!-- Thống kê tổng quan -->
            <div class="row">
                <div class="col-lg-3 col-xs-6">
                    <div class="small-box bg-aqua">
                        <div class="inner">
                            <h3 id="totalReservations">0</h3>
                            <p>Tổng lịch đặt</p>
                        </div>
                        <div class="icon"><i class="fa fa-calendar"></i></div>
                    </div>
                </div>

                <div class="col-lg-3 col-xs-6">
                    <div class="small-box bg-green">
                        <div class="inner">
                            <h3 id="totalRevenue">0₫</h3>
                            <p>Tổng doanh thu</p>
                        </div>
                        <div class="icon"><i class="fa fa-money"></i></div>
                    </div>
                </div>

                <div class="col-lg-3 col-xs-6">
                    <div class="small-box bg-red">
                        <div class="inner">
                            <h3 id="totalCanceled">0</h3>
                            <p>Lượt hủy</p>
                        </div>
                        <div class="icon"><i class="fa fa-ban"></i></div>
                    </div>
                </div>
            </div>

            <!-- Biểu đồ -->
            <div class="row">
                <div class="col-md-6">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">Doanh thu theo thời gian</h3>
                        </div>
                        <div class="box-body">
                            <canvas id="revenueChart" height="200"></canvas>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="box box-info">
                        <div class="box-header with-border">
                            <h3 class="box-title">Lịch đặt theo thời gian</h3>
                        </div>
                        <div class="box-body">
                            <canvas id="reservationChart" height="200"></canvas>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
</div>

<!-- JS -->
<script src="${pageContext.request.contextPath}/adminlte/plugins/jQuery/jquery-2.2.3.min.js"></script>
<script src="${pageContext.request.contextPath}/adminlte/bootstrap/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/adminlte/dist/js/app.min.js"></script>

<script>
    $(function() {
        // Tổng quan
        $.getJSON("${pageContext.request.contextPath}/api/dashboard/overview", function(data) {
            $("#totalReservations").text(data.totalReservations);
            $("#totalRevenue").text(data.totalRevenue.toLocaleString('vi-VN') + "₫");
            $("#totalCanceled").text(data.totalCanceled);
        });

        // Biểu đồ doanh thu
        $.getJSON("${pageContext.request.contextPath}/api/dashboard/revenue?type=month", function(data) {
            new Chart(document.getElementById("revenueChart"), {
                type: "line",
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: "Doanh thu (VNĐ)",
                        data: data.values,
                        borderColor: "rgba(60,141,188,1)",
                        backgroundColor: "rgba(60,141,188,0.3)",
                        fill: true,
                        tension: 0.4
                    }]
                }
            });
        });

        // Biểu đồ lịch đặt
        $.getJSON("${pageContext.request.contextPath}/api/dashboard/reservations?type=month", function(data) {
            new Chart(document.getElementById("reservationChart"), {
                type: "bar",
                data: {
                    labels: data.labels,
                    datasets: [{
                        label: "Số lượng lịch đặt",
                        data: data.values,
                        backgroundColor: "rgba(0,166,90,0.6)"
                    }]
                }
            });
        });
    });
</script>
</body>
</html>
