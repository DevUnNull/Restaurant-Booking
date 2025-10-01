// Reservation Page JavaScript

// Global variables
let scene, camera, renderer, controls;
let tables = [];
let selectedTable = null;
let reservationData = {};

// Initialize reservation page
document.addEventListener('DOMContentLoaded', function() {
    loadReservationData();
    initializeDateTime();
    initialize3DScene();
    setupFormValidation();
    setupEventListeners();
});

// Load reservation data from server
function loadReservationData() {
    const dataElement = document.getElementById('reservationData');
    if (dataElement) {
        try {
            reservationData = JSON.parse(dataElement.textContent);
        } catch (error) {
            console.error('Error parsing reservation data:', error);
            reservationData = {
                validTableCodes: [1, 4, 7, 10, 13, 16, 19, 22, 25],
                bookedTables: [],
                minDate: new Date().toISOString().split('T')[0],
                maxDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0],
                availableTimeSlots: ["11:00", "11:30", "12:00", "12:30", "13:00", "13:30", "18:00", "18:30", "19:00", "19:30", "20:00", "20:30"]
            };
        }
    }
}

// Initialize date and time inputs
function initializeDateTime() {
    const dateInput = document.getElementById('reservationDate');
    const timeInput = document.getElementById('reservationTime');
    
    // Set minimum date to today
    const today = new Date().toISOString().split('T')[0];
    dateInput.min = reservationData.minDate || today;
    
    // Set maximum date (30 days from now)
    if (reservationData.maxDate) {
        dateInput.max = reservationData.maxDate;
    }
    
    // Populate time slots
    if (reservationData.availableTimeSlots && reservationData.availableTimeSlots.length > 0) {
        // Create datalist for time suggestions
        const datalist = document.createElement('datalist');
        datalist.id = 'timeSlots';
        
        reservationData.availableTimeSlots.forEach(time => {
            const option = document.createElement('option');
            option.value = time;
            datalist.appendChild(option);
        });
        
        timeInput.setAttribute('list', 'timeSlots');
        document.body.appendChild(datalist);
    }
}

// Initialize 3D Scene
function initialize3DScene() {
    const container = document.getElementById('canvas-container');
    const loadingIndicator = document.getElementById('loadingIndicator');
    
    // Setup scene, camera, renderer
    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(75, container.clientWidth / container.clientHeight, 0.1, 1000);
    renderer = new THREE.WebGLRenderer({ antialias: true });
    
    renderer.setSize(container.clientWidth, container.clientHeight);
    renderer.setClearColor(0xf0f0f0);
    renderer.shadowMap.enabled = true;
    renderer.shadowMap.type = THREE.PCFSoftShadowMap;
    
    container.appendChild(renderer.domElement);
    
    // Setup lighting
    const ambientLight = new THREE.AmbientLight(0xffffff, 0.6);
    scene.add(ambientLight);
    
    const directionalLight = new THREE.DirectionalLight(0xffffff, 0.8);
    directionalLight.position.set(10, 10, 5);
    directionalLight.castShadow = true;
    directionalLight.shadow.mapSize.width = 2048;
    directionalLight.shadow.mapSize.height = 2048;
    scene.add(directionalLight);
    
    // Setup camera position
    camera.position.set(0, 150, 300);
    camera.lookAt(0, 0, 0);
    
    // Setup controls
    controls = new THREE.OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.05;
    controls.screenSpacePanning = false;
    controls.minDistance = 50;
    controls.maxDistance = 500;
    controls.maxPolarAngle = Math.PI / 2;
    
    // Load 3D model
    load3DModel(loadingIndicator);
    
    // Start animation loop
    animate();
    
    // Handle window resize
    window.addEventListener('resize', onWindowResize);
}

// Load 3D Restaurant Model
function load3DModel(loadingIndicator) {
    const loader = new THREE.GLTFLoader();
    
    // Try to load the model, fallback to creating simple geometry if not found
    loader.load(
        getContextPath() + '/assets/models/scene.gltf',
        (gltf) => {
            const model = gltf.scene;
            scene.add(model);
            
            // Scale and position the model
            model.position.set(0, 0, 0);
            model.scale.set(15, 15, 15);
            
            // Process tables in the model
            processModelTables(model);
            
            // Hide loading indicator
            loadingIndicator.style.display = 'none';
            
            console.log('3D model loaded successfully');
        },
        (progress) => {
            const percent = Math.round((progress.loaded / progress.total) * 100);
            loadingIndicator.querySelector('p').textContent = `Loading restaurant layout... ${percent}%`;
        },
        (error) => {
            console.warn('Could not load 3D model, creating fallback layout:', error);
            createFallbackLayout();
            loadingIndicator.style.display = 'none';
        }
    );
}

// Process tables from the loaded model
function processModelTables(model) {
    let tableCounter = 1;
    
    model.traverse((child) => {
        if (child.isMesh) {
            const boundingBox = new THREE.Box3().setFromObject(child);
            const size = new THREE.Vector3();
            boundingBox.getSize(size);
            
            // Identify tables based on size (adjust these values based on your model)
            if (size.x > 0.5 && size.x < 50 && size.y < 10 && size.z > 0.5 && size.z < 50) {
                const tableCode = reservationData.validTableCodes[tableCounter - 1];
                
                if (tableCode) {
                    child.userData = {
                        tableCode: tableCode,
                        booked: reservationData.bookedTables.includes(tableCode),
                        originalMaterial: child.material ? child.material.clone() : null
                    };
                    
                    tables.push(child);
                    tableCounter++;
                    
                    // Make table clickable
                    child.cursor = 'pointer';
                }
            }
        }
    });
    
    console.log(`Found ${tables.length} tables in the model`);
    setupTableInteraction();
}

// Create fallback layout if 3D model fails to load
function createFallbackLayout() {
    const floorGeometry = new THREE.PlaneGeometry(200, 200);
    const floorMaterial = new THREE.MeshLambertMaterial({ color: 0xffffff });
    const floor = new THREE.Mesh(floorGeometry, floorMaterial);
    floor.rotation.x = -Math.PI / 2;
    floor.receiveShadow = true;
    scene.add(floor);
    
    // Create simple table representations
    reservationData.validTableCodes.forEach((tableCode, index) => {
        const tableGeometry = new THREE.BoxGeometry(8, 2, 8);
        const tableMaterial = new THREE.MeshLambertMaterial({ 
            color: reservationData.bookedTables.includes(tableCode) ? 0xff6b6b : 0x8b4513 
        });
        const table = new THREE.Mesh(tableGeometry, tableMaterial);
        
        // Position tables in a grid
        const row = Math.floor(index / 3);
        const col = index % 3;
        table.position.set((col - 1) * 30, 1, (row - 1) * 30);
        table.castShadow = true;
        
        table.userData = {
            tableCode: tableCode,
            booked: reservationData.bookedTables.includes(tableCode),
            originalMaterial: tableMaterial.clone()
        };
        
        tables.push(table);
        scene.add(table);
        
        // Add table number label
        const canvas = document.createElement('canvas');
        const context = canvas.getContext('2d');
        canvas.width = 128;
        canvas.height = 64;
        context.fillStyle = '#ffffff';
        context.fillRect(0, 0, 128, 64);
        context.fillStyle = '#000000';
        context.font = '24px Arial';
        context.textAlign = 'center';
        context.fillText(`Table ${tableCode}`, 64, 40);
        
        const texture = new THREE.CanvasTexture(canvas);
        const labelMaterial = new THREE.MeshBasicMaterial({ map: texture });
        const labelGeometry = new THREE.PlaneGeometry(8, 4);
        const label = new THREE.Mesh(labelGeometry, labelMaterial);
        label.position.copy(table.position);
        label.position.y += 3;
        label.lookAt(camera.position);
        scene.add(label);
    });
    
    setupTableInteraction();
    console.log('Fallback layout created');
}

// Setup table interaction (clicking)
function setupTableInteraction() {
    const raycaster = new THREE.Raycaster();
    const mouse = new THREE.Vector2();
    
    renderer.domElement.addEventListener('click', (event) => {
        // Calculate mouse position in normalized device coordinates
        const rect = renderer.domElement.getBoundingClientRect();
        mouse.x = ((event.clientX - rect.left) / rect.width) * 2 - 1;
        mouse.y = -((event.clientY - rect.top) / rect.height) * 2 + 1;
        
        // Update the picking ray with the camera and mouse position
        raycaster.setFromCamera(mouse, camera);
        
        // Calculate objects intersecting the picking ray
        const intersects = raycaster.intersectObjects(tables);
        
        if (intersects.length > 0) {
            const clickedTable = intersects[0].object;
            selectTable(clickedTable.userData.tableCode);
        }
    });
}

// Select a table
function selectTable(tableCode) {
    const table = tables.find(t => t.userData.tableCode === tableCode);
    
    if (!table) {
        showFormStatus('Table not found!', 'error');
        return;
    }
    
    if (table.userData.booked) {
        showFormStatus(`Table ${tableCode} is already booked!`, 'error');
        return;
    }
    
    // Reset previous selection
    if (selectedTable) {
        selectedTable.material = selectedTable.userData.originalMaterial;
    }
    
    // Select new table
    selectedTable = table;
    const selectedMaterial = selectedTable.userData.originalMaterial.clone();
    selectedMaterial.color.setHex(0x007bff);
    selectedMaterial.emissive.setHex(0x002244);
    selectedTable.material = selectedMaterial;
    
    // Update form
    document.getElementById('tableCode').value = tableCode;
    showFormStatus(`Table ${tableCode} selected successfully!`, 'success');
}

// Select table from list (helper function)
function selectTableFromList(tableCode) {
    selectTable(tableCode);
}

// Setup form validation
function setupFormValidation() {
    const form = document.getElementById('reservationForm');
    const inputs = form.querySelectorAll('input[required], select[required]');
    
    inputs.forEach(input => {
        input.addEventListener('blur', validateField);
        input.addEventListener('input', clearFieldError);
    });
    
    // Table code validation
    const tableCodeInput = document.getElementById('tableCode');
    tableCodeInput.addEventListener('input', validateTableCode);
}

// Validate individual field
function validateField(event) {
    const field = event.target;
    const value = field.value.trim();
    
    // Remove existing error styling
    field.classList.remove('error');
    
    // Validate based on field type
    switch (field.type) {
        case 'email':
            if (value && !isValidEmail(value)) {
                showFieldError(field, 'Please enter a valid email address');
            }
            break;
        case 'tel':
            if (value && !isValidPhone(value)) {
                showFieldError(field, 'Please enter a valid phone number');
            }
            break;
        case 'date':
            if (value && !isValidDate(value)) {
                showFieldError(field, 'Please select a valid date');
            }
            break;
        case 'time':
            if (value && !isValidTime(value)) {
                showFieldError(field, 'Please select a valid time');
            }
            break;
    }
}

// Validate table code
function validateTableCode(event) {
    const tableCode = parseInt(event.target.value);
    const statusDiv = document.getElementById('formStatus');
    
    if (isNaN(tableCode)) {
        statusDiv.style.display = 'none';
        return;
    }
    
    if (!reservationData.validTableCodes.includes(tableCode)) {
        showFormStatus(`Invalid table number! Available tables: ${reservationData.validTableCodes.join(', ')}`, 'error');
        return;
    }
    
    if (reservationData.bookedTables.includes(tableCode)) {
        showFormStatus(`Table ${tableCode} is already booked!`, 'error');
        return;
    }
    
    // Auto-select table in 3D view
    selectTable(tableCode);
}

// Clear field error
function clearFieldError(event) {
    const field = event.target;
    field.classList.remove('error');
    
    // Clear field-specific error message
    const errorMsg = field.parentNode.querySelector('.field-error');
    if (errorMsg) {
        errorMsg.remove();
    }
}

// Show field error
function showFieldError(field, message) {
    field.classList.add('error');
    
    // Remove existing error message
    const existingError = field.parentNode.querySelector('.field-error');
    if (existingError) {
        existingError.remove();
    }
    
    // Add new error message
    const errorDiv = document.createElement('div');
    errorDiv.className = 'field-error';
    errorDiv.style.cssText = 'color: #dc3545; font-size: 0.875rem; margin-top: 0.25rem;';
    errorDiv.textContent = message;
    field.parentNode.appendChild(errorDiv);
}

// Setup event listeners
function setupEventListeners() {
    const form = document.getElementById('reservationForm');
    
    form.addEventListener('submit', handleFormSubmit);
    
    // Phone number formatting
    const phoneInput = document.getElementById('customerPhone');
    phoneInput.addEventListener('input', formatPhoneNumber);
}

// Handle form submission
function handleFormSubmit(event) {
    event.preventDefault();
    
    const form = event.target;
    const submitBtn = document.getElementById('submitBtn');
    const btnText = submitBtn.querySelector('.btn-text');
    const btnLoading = submitBtn.querySelector('.btn-loading');
    
    // Validate form
    if (!validateForm(form)) {
        return;
    }
    
    // Show loading state
    submitBtn.disabled = true;
    btnText.style.display = 'none';
    btnLoading.style.display = 'inline-flex';
    
    // Prepare form data
    const formData = new FormData(form);
    
    // Submit form
    fetch(form.action, {
        method: 'POST',
        body: formData,
        headers: {
            'X-Requested-With': 'XMLHttpRequest'
        }
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            showFormStatus('Reservation submitted successfully! We will contact you shortly.', 'success');
            resetForm();
            
            // Mark table as booked in 3D view
            if (selectedTable) {
                selectedTable.userData.booked = true;
                const bookedMaterial = selectedTable.userData.originalMaterial.clone();
                bookedMaterial.color.setHex(0xdc3545);
                selectedTable.material = bookedMaterial;
                selectedTable = null;
            }
        } else {
            showFormStatus(data.message || 'Failed to submit reservation. Please try again.', 'error');
        }
    })
    .catch(error => {
        console.error('Error submitting reservation:', error);
        showFormStatus('An error occurred. Please try again later.', 'error');
    })
    .finally(() => {
        // Reset button state
        submitBtn.disabled = false;
        btnText.style.display = 'inline';
        btnLoading.style.display = 'none';
    });
}

// Validate entire form
function validateForm(form) {
    const requiredFields = form.querySelectorAll('[required]');
    let isValid = true;
    
    requiredFields.forEach(field => {
        if (!field.value.trim()) {
            showFieldError(field, 'This field is required');
            isValid = false;
        }
    });
    
    // Additional validations
    const email = document.getElementById('customerEmail').value.trim();
    if (email && !isValidEmail(email)) {
        showFieldError(document.getElementById('customerEmail'), 'Please enter a valid email address');
        isValid = false;
    }
    
    const phone = document.getElementById('customerPhone').value.trim();
    if (!isValidPhone(phone)) {
        showFieldError(document.getElementById('customerPhone'), 'Please enter a valid phone number');
        isValid = false;
    }
    
    const tableCode = parseInt(document.getElementById('tableCode').value);
    if (!reservationData.validTableCodes.includes(tableCode)) {
        showFieldError(document.getElementById('tableCode'), 'Please select a valid table');
        isValid = false;
    }
    
    return isValid;
}

// Reset form
function resetForm() {
    const form = document.getElementById('reservationForm');
    form.reset();
    
    // Clear all error messages
    const errorMessages = form.querySelectorAll('.field-error');
    errorMessages.forEach(msg => msg.remove());
    
    // Clear field error styling
    const errorFields = form.querySelectorAll('.error');
    errorFields.forEach(field => field.classList.remove('error'));
    
    // Reset table selection
    if (selectedTable) {
        selectedTable.material = selectedTable.userData.originalMaterial;
        selectedTable = null;
    }
    
    // Hide status message
    document.getElementById('formStatus').style.display = 'none';
}

// Show form status message
function showFormStatus(message, type) {
    const statusDiv = document.getElementById('formStatus');
    statusDiv.className = `form-status ${type}`;
    statusDiv.textContent = message;
    statusDiv.style.display = 'block';
    
    // Auto-hide success messages after 5 seconds
    if (type === 'success') {
        setTimeout(() => {
            statusDiv.style.display = 'none';
        }, 5000);
    }
}

// Animation loop
function animate() {
    requestAnimationFrame(animate);
    controls.update();
    renderer.render(scene, camera);
}

// Handle window resize
function onWindowResize() {
    const container = document.getElementById('canvas-container');
    camera.aspect = container.clientWidth / container.clientHeight;
    camera.updateProjectionMatrix();
    renderer.setSize(container.clientWidth, container.clientHeight);
}

// Utility functions
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

function isValidPhone(phone) {
    const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/;
    const cleanPhone = phone.replace(/[\s\-\(\)]/g, '');
    return phoneRegex.test(cleanPhone) && cleanPhone.length >= 10;
}

function isValidDate(dateString) {
    const date = new Date(dateString);
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    return date >= today;
}

function isValidTime(timeString) {
    const timeRegex = /^([01]?[0-9]|2[0-3]):[0-5][0-9]$/;
    return timeRegex.test(timeString);
}

function formatPhoneNumber(event) {
    let value = event.target.value.replace(/\D/g, '');
    
    if (value.length >= 10) {
        value = value.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3');
    } else if (value.length >= 6) {
        value = value.replace(/(\d{3})(\d{3})/, '($1) $2');
    } else if (value.length >= 3) {
        value = value.replace(/(\d{3})/, '($1)');
    }
    
    event.target.value = value;
}

function getContextPath() {
    return window.location.pathname.substring(0, window.location.pathname.indexOf('/', 1)) || '';
}

// Export functions for global access
window.selectTableFromList = selectTableFromList;
window.resetForm = resetForm;