<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<c:if test="${empty sessionScope.account}">
    <c:redirect url="login.jsp"/>
</c:if>

<c:if test="${not empty sessionScope.account}">
    <c:choose>
        <c:when test="${sessionScope.account.roleId != '2' && sessionScope.account.roleId != '3'}">
            <c:redirect url="404.html"/>
        </c:when>
    </c:choose>
</c:if>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Reservation List</title>
        <link rel="shortcut icon" href="img/favicon.png">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
        <style>
            .table-container {
                width: 100%;
                margin: auto;
                background-color: #f9f9f9;
                padding: 20px;
                border-radius: 8px;
                min-height: 500px;
            }

            .table-header {
                display: flex;
                justify-content: space-between;
                margin-bottom: 10px;
            }

            .search-box input {
                padding: 8px;
                border-radius: 4px;
                border: 1px solid #ccc;
                width: 250px;
            }

            .search-box button {
                padding: 8px;
                background-color: #0a58ca;
                border: none;
                border-radius: 4px;
                color: white;
            }

            .slider-table {
                width: 100%;
                border-collapse: collapse;
                table-layout: fixed;
            }

            .slider-table th, .slider-table td {
                text-align: left;
                padding: 12px;
                border-bottom: 1px solid #ddd;
            }

            .slider-table th {
                background-color: #f2f2f2;
            }

            .reservation-tabs {
                display: flex;
                justify-content: space-between;
                margin-bottom: 20px;
            }

            .tabs {
                display: flex;
                justify-content: space-around;
                border-bottom: 2px solid #f0f0f0;
                margin-bottom: 10px;
            }

            .tab-button {
                padding: 10px 20px;
                cursor: pointer;
                font-size: 16px;
                font-weight: 500;
                color: #666;
                text-decoration: none;
                border-bottom: 2px solid transparent;
                transition: color 0.3s ease, border-bottom 0.3s ease;
            }

            .tab-button.active {
                color: #e40d0d;
                border-bottom: 2px solid #e40d0d;
            }

            .tab-button:hover {
                color: #e40d0d;
            }


            #pagination {
                display: flex;
                align-items: center;
                justify-content: center;
                flex-direction: column;
            }

            #pagination ul {
                list-style: none;
                padding: 0;
                margin: 0;
                display: flex;
            }

            #pagination ul li {
                color: #fff;
                display: flex;
            }

            #pagination ul li a {
                background-color: #fff;
                padding: 5px 10px;
                border: 2px solid #ccc;
                text-decoration: none;
                color: #333;
            }

            #pagination ul li a:hover {
                background-color: #333;
                color: #fff;
            }

            #pagination ul li.active a {
                background-color: #333 !important;
                border-color: #0a58ca;
                color: #fff;
            }

            .page-item a {
                text-decoration: none;
            }
            .nav-link.active {
                background-color: white !important;
                color: #0a58ca;
                font-weight: bold;
            }

            .nav-link {
                color: #666;
                transition: background-color 0.3s ease, color 0.3s ease;
            }

            .nav-link:hover {
                background-color: #f0f0f0;
                color: #0a58ca;
            }

            .nav-link.active:hover {
                background-color: white;
                color: #0a58ca;
            }

            .service-details {
                margin-top: 20px;
            }

            .service-price {
                font-weight: bold;
                color: #0a58ca;
            }

            .status-badge {
                padding: 5px 10px;
                border-radius: 4px;
                font-weight: bold;
            }

            .status-pending {
                color: orange;
            }
            .status-submit {
                color: blue;
            }
            .status-approved {
                color: green;
            }
            .status-success {
                color: #37F525;
            }
            .status-cancel {
                color: red;
            }

            .total-section {
                border-top: 2px solid #eee;
                padding-top: 20px;
            }

        </style>
        <!-- jQuery first -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <!-- Then Popper.js -->
        <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
        <!-- Then Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Then Bootstrap JS Bundle (includes Popper) -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <div class="page-wrapper doctris-theme toggled">
            <jsp:include page="../common/admin/side_bar_admin.jsp"></jsp:include>
                <main class="page-content bg-light">
                <jsp:include page="../common/common-homepage-header.jsp"></jsp:include>
                    <section class="container-fluid" style="padding: 20px; margin-top: 30px; margin-bottom: 30px">
                        <div class="bread_crumb">
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb" style="background-color: white; box-shadow: 0 0 2px 2px rgba(128, 128, 128, 0.1);">
                                    <li class="breadcrumb-item"><a href="HomeServlet">Home</a></li>
                                    <li class="breadcrumb-item"><a href="./profile">Manager Dashboard</a></li>
                                    <li class="breadcrumb-item active" aria-current="page">My Reservation</li>
                                </ol>
                            </nav>
                        </div>
                        <a id="close-sidebar" class="btn btn-icon btn-pills btn-soft-primary ms-2" href="#" style="margin-bottom:20px">
                            <i class="uil uil-bars"></i>
                        </a>
                        <ul class="nav nav-pills nav-justified flex-column flex-sm-row rounded-0 shadow overflow-hidden bg-white mb-0" id="pills-tab" role="tablist">
                            <li class="nav-item">
                                <a class="nav-link rounded-0 active" id="overview-tab" data-bs-toggle="pill" href="#pills-overview" role="tab" aria-controls="pills-overview" aria-selected="false">
                                    <div class="text-center pt-1 pb-1">
                                        <h4 class="title fw-normal mb-0" style="height: 20px"></h4>
                                    </div>
                                </a><!--end nav link-->
                            </li><!--end nav item-->
                        </ul>
                        <div class="slider-list" style="background-color: white; padding: 10px;box-shadow: 0 0 2px 2px rgba(128, 128, 128, 0.1);">
                            <div class="table-container" style="background-color: white;">
                                <div class="table-header">
                                    <div class="search-box">
                                        <input type="text" placeholder="Search by first service name" id="searchInput" onkeyup="applyFilters()">
                                        <button type="button">
                                            <i class="fa fa-search"></i>
                                        </button>
                                    </div>
                                    <div class="row">
                                        <div class="status-filter col" style="display: flex; gap: 10px" >
                                            <div>Filter:</div>
                                            <select id="statusFilter" onchange="applyFilters()">
                                                <option value="" class="label">Status</option>
                                                <option value="all">All</option>
                                                <option value="Pending">Pending</option>
                                                <option value="Approved">Approved</option>
                                                <option value="Waiting for payment">Waiting for payment</option>
                                                <option value="In Progress">In Progress</option>
                                                <option value="Examining">Examining</option>
                                                <option value="Examined">Examined</option>
                                                <option value="Completed">Completed</option>
                                                <option value="Cancelled">Cancelled</option>
                                            </select>
                                            <select id="serviceFilter" onchange="applyFilters()">
                                                <option value="" class="label">Service</option>
                                                <option value="all">All Services</option>
                                            <c:forEach var="service" items="${service.getAllService()}">
                                                <option value="${service.getFullname().trim()}">${service.getFullname()}</option>
                                            </c:forEach>

                                        </select>
                                    </div>
                                </div>
                            </div>
                            <table class="slider-table .table-striped">
                                <thead>
                                <th onclick="sortTable(0)">Reservation ID</th>
                                <th onclick="sortTable(1)">Customer Name</th> 
                                <th onclick="sortTable(2)">Reservation Date</th>
                                <th onclick="sortTable(3)">First Service</th>
                                <th onclick="sortTable(4)">Checkup Time</th>
                                <th>Status</th>
                                <th onclick="sortTable(6)">Total Cost</th>
                                <th>Action</th>
                                </thead>
                                <tbody id="reservationTableBody">
                                    <c:forEach var="res" items="${reservation}">
                                        <tr style="cursor: pointer;" onclick="window.location.href = './ReservationServlet?action=information&id=${res.getId()}'">
                                            <td>${res.getId()}</td>
                                            <c:forEach var="user" items="${users}">
                                                <c:if test="${user.getId()==res.getCustomer_id()}">
                                                    <td>${user.getFullName()}</td>
                                                </c:if>
                                            </c:forEach>
                                            <td>${res.getReservation_date()}</td>
                                            <td>${res.getList_service().get(0).getService_name()}</td>
                                            <td>${res.getCheckup_time()}</td>
                                            <td  style="font-weight: bold">
                                                <c:choose>
                                                    <c:when test="${res.status == 'Pending'}">
                                                        <span style="color: orange;">Pending</span>
                                                    </c:when>
                                                    <c:when test="${res.status == 'Approved'}">
                                                        <span style="color: green;">Approved</span>
                                                    </c:when>
                                                    <c:when test="${res.status == 'Successful'}">
                                                        <span style="color: #37F525;">Successful</span>
                                                    </c:when>
                                                    <c:when test="${res.status == 'Cancelled'}">
                                                        <span style="color: red;">Cancelled</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span>${res.getStatus()}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:set var="totalCost" value="0" />
                                                <c:forEach var="service" items="${res.getList_service()}">
                                                    <c:set var="itemCost" value="${service.getQuantity() * service.getUnit_price()}" />
                                                    <c:set var="totalCost" value="${totalCost + itemCost}" />
                                                </c:forEach>
                                                <c:out value="${totalCost}" />
                                            </td>
                                            <td>
                                                <button type="button" 
                                                        class="btn btn-primary btn-sm" 
                                                        style="margin-bottom: 8px"
                                                        onclick="event.stopPropagation(); viewReservationDetails(${res.getId()})" 
                                                        data-bs-toggle="modal" 
                                                        data-bs-target="#reservationModal">
                                                    View Details
                                                </button>
                                                <c:if test="${fn:toLowerCase(res.status) == 'pending'}">
                                                    <button type="button" 
                                                            class="btn btn-success btn-sm" 
                                                            onclick="event.stopPropagation(); approveReservation(${res.getId()})"
                                                            style="width: 100px;">
                                                        Approve
                                                    </button>
                                                    <button type="button" 
                                                            class="btn btn-danger btn-sm mt-2" 
                                                            onclick="event.stopPropagation(); cancelReservation(${res.getId()})"
                                                            style="width: 100px;">
                                                        Cancel
                                                    </button>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                            <div id="pagination"></div>
                        </div>
                    </div>
                </section>
                <jsp:include page="../common/common-homepage-footer.jsp"></jsp:include>
            </main>
        </div>
    </body>
    <!-- Bootstrap Modal -->
    <!-- Update your modal HTML -->
    <div class="modal fade" id="reservationModal" tabindex="-1" data-bs-backdrop="static" aria-labelledby="modalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalLabel">Reservation Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body" id="modalContent">
                    <div class="spinner-border text-primary" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                </div>
                <!--                <div class="modal-footer">
                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                </div>-->
            </div>
        </div>
    </div>
    <!-- JavaScript for filtering reservations -->
    <script>
        let currentPage = 1;
        const rowsPerPage = 5;
        let allRows = [];
        let filteredRows = [];

        function initializeTable() {
            const table = document.getElementById('reservationTableBody');
            allRows = Array.from(table.getElementsByTagName('tr'));
            filteredRows = allRows;
            applyFilters();
        }
        function applyFilters() {
            const searchValue = document.getElementById('searchInput').value.toLowerCase().trim();
            const statusFilter = document.getElementById("statusFilter").value.toLowerCase();
            const serviceFilter = document.getElementById("serviceFilter").value.toLowerCase();

            filteredRows = allRows.filter(row => {
                const cells = row.getElementsByTagName("td");
                const fullname = cells[3].innerText.toLowerCase();
                const serviceName = cells[3].innerText.toLowerCase();
                const status = cells[5].innerText.toLowerCase();

                return (fullname.includes(searchValue) &&
                        (statusFilter === "all" || status.includes(statusFilter)) &&
                        (serviceFilter === "all" || serviceName.includes(serviceFilter))
                        );
            });
            currentPage = 1;
            displayTable();
        }
        function displayTable() {
            const table = document.getElementById('reservationTableBody');
            const totalRows = filteredRows.length;

            Array.from(table.children).forEach(row => row.style.display = "none");

            const startIndex = (currentPage - 1) * rowsPerPage;
            const endIndex = Math.min(startIndex + rowsPerPage, totalRows);

            for (let i = startIndex; i < endIndex; i++) {
                if (filteredRows[i])
                    filteredRows[i].style.display = "";
            }

            createPagination(Math.ceil(totalRows / rowsPerPage), currentPage);
        }

        function createPagination(totalPages, currentPage) {
            let pagination = document.getElementById('pagination');
            let str = '<ul>';
            let active;

            if (currentPage > 1) {
                str += '<li class="page-item previous no"><a onclick="goToPage(' + (currentPage - 1) + ')">Previous</a></li>';
            }

            let maxVisiblePages = 6;
            let startPage = Math.max(1, currentPage - 2);
            let endPage = Math.min(totalPages, currentPage + 2);

            if (totalPages > maxVisiblePages) {
                if (startPage > 1) {
                    str += '<li class="no"><a onclick="goToPage(1)">1</a></li>';
                    if (startPage > 2) {
                        str += '<li class="no" style="color: black; padding: 5px 10px;border: 2px solid #ccc;">...</li>';
                    }
                }

                for (let p = startPage; p <= endPage; p++) {
                    active = currentPage === p ? "active" : "no";
                    str += '<li class="' + active + '"><a onclick="goToPage(' + p + ')">' + p + '</a></li>';
                }

                if (endPage < totalPages - 1) {
                    str += '<li class="no" style="color: black; padding: 5px 10px;border: 2px solid #ccc;">...</li>';
                }
                if (endPage < totalPages) {
                    str += '<li class="no"><a onclick="goToPage(' + totalPages + ')">' + totalPages + '</a></li>';
                }
            } else {
                for (let p = 1; p <= totalPages; p++) {
                    active = currentPage === p ? "active" : "no";
                    str += '<li class="' + active + '"><a onclick="goToPage(' + p + ')">' + p + '</a></li>';
                }
            }

            if (currentPage < totalPages) {
                str += '<li class="page-item next no"><a onclick="goToPage(' + (currentPage + 1) + ')">Next</a></li>';
            }
            str += '</ul>';

            pagination.innerHTML = str;
        }

        function goToPage(pageNumber) {
            currentPage = pageNumber;
            displayTable();
        }
        function sortTable(columnIndex) {
            const table = document.getElementById("reservationTableBody");
            const isAscending = table.dataset.sortOrder === "asc";

            filteredRows.sort((a, b) => {
                let aValue, bValue;

                if (columnIndex === 0 || columnIndex === 6) {
                    aValue = parseInt(a.cells[columnIndex].innerText);
                    bValue = parseInt(b.cells[columnIndex].innerText);
                    return isAscending ? aValue - bValue : bValue - aValue;
                } else if (columnIndex === 2 || columnIndex === 4) {
                    aValue = Date.parse(a.cells[columnIndex].innerText);
                    bValue = Date.parse(b.cells[columnIndex].innerText);
                    return isAscending ? aValue - bValue : bValue - aValue;
                } else if (columnIndex === 1 || columnIndex === 3) {
                    aValue = a.cells[columnIndex].innerText.toLowerCase();
                    bValue = b.cells[columnIndex].innerText.toLowerCase();
                    return isAscending ? aValue.localeCompare(bValue) : bValue.localeCompare(aValue);
                }

                return 0;
            });

            while (table.firstChild) {
                table.removeChild(table.firstChild);
            }
            filteredRows.forEach(row => table.appendChild(row));

            table.dataset.sortOrder = isAscending ? "desc" : "asc";
            displayTable();
        }

        window.onload = initializeTable;
    </script>
    <script>
        // Add this after your modal HTML
        document.getElementById('reservationModal').addEventListener('hidden.bs.modal', function () {
            document.body.classList.remove('modal-open');
            document.querySelector('.modal-backdrop').remove();
        });

        // Update your viewReservationDetails function
        function viewReservationDetails(reservationId) {
            event.preventDefault();
            event.stopPropagation();

            const modalContent = document.getElementById("modalContent");
            modalContent.innerHTML = `
        <div class="text-center">
            <div class="spinner-border text-primary" role="status">
                <span class="visually-hidden">Loading...</span>
            </div>
        </div>`;

            const modal = new bootstrap.Modal(document.getElementById('reservationModal'));
            modal.show();

            $.ajax({
                url: 'ReservationServlet',
                type: 'POST',
                data: {
                    action: 'getDetails',
                    id: reservationId
                },
                success: function (response) {
                    modalContent.innerHTML = response;
                },
                error: function (xhr, status, error) {
                    modalContent.innerHTML = `
                <div class="alert alert-danger" role="alert">
                    Error loading reservation details. Please try again later.
                </div>`;
                }
            });
        }
        function cancelReservation(reservationId) {
            if (!confirm("Are you sure you want to cancel this appointment?")) {
                return;
            }

            $.ajax({
                url: 'ReservationServlet',
                type: 'POST',
                data: {
                    action: 'cancelReservation',
                    id: reservationId
                },
                success: function (response) {
                    if (response.success) {
                        alert(response.message);
                        // Close modal
                        $('#reservationModal').modal('hide');
                        // Reload page to update reservation list
                        location.reload();
                    } else {
                        alert(response.message);
                    }
                },
                error: function (xhr, status, error) {
                    alert('Error cancelling reservation: ' + error);
                }
            });
        }
    </script>
    <script>
        function approveReservation(reservationId) {
            if (!confirm("Are you sure you want to approve this reservation?")) {
                return;
            }

            $.ajax({
                url: 'reservation-manager',
                type: 'POST',
                data: {
                    action: 'approveReservation',
                    id: reservationId
                },
                success: function () {
                    window.location.href = 'reservation-manager';
                }
            });
        }

        function cancelReservation(reservationId) {
            if (!confirm("Are you sure you want to cancel this reservation?")) {
                return;
            }

            $.ajax({
                url: 'reservation-manager',
                type: 'POST',
                data: {
                    action: 'cancelReservation',
                    id: reservationId
                },
                success: function () {
                    window.location.href = 'reservation-manager';
                }
            });
        }
    </script>
</html>
