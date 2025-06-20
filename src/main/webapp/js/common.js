// Toast function for showing messages
function showToast(message, type) {
    const toast = document.querySelector('.toast');
    const toastBody = toast.querySelector('.toast-body');
    
    toastBody.textContent = message;
    toast.className = 'toast align-items-center text-white border-0 ' + type;
    
    const bsToast = new bootstrap.Toast(toast);
    bsToast.show();
}

// Add event listeners to all cart forms
function initializeCartForms() {
    document.querySelectorAll('form.cart-form').forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('Cart form submitted');
            fetch(this.action, {
                method: 'POST',
                body: new FormData(this)
            })
            .then(response => {
                console.log('Cart response received:', response);
                return response.json();
            })
            .then(data => {
                console.log('Cart data processed:', data);
                if (data.success) {
                    showToast(data.message, 'bg-success');
                    if (data.redirect) {
                        setTimeout(() => {
                            window.location.href = data.redirect;
                        }, 1000);
                    }
                } else {
                    showToast(data.message, 'bg-danger');
                    if (data.redirect) {
                        setTimeout(() => {
                            window.location.href = data.redirect;
                        }, 1000);
                    }
                }
            })
            .catch(error => {
                console.error('Cart error:', error);
                showToast('Error processing request', 'bg-danger');
            });
        });
    });
}

// Add event listeners to all wishlist forms
function initializeWishlistForms() {
    document.querySelectorAll('form.wishlist-form').forEach(form => {
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            console.log('Wishlist form submitted');
            fetch(this.action, {
                method: 'POST',
                body: new FormData(this)
            })
            .then(response => {
                console.log('Wishlist response received:', response);
                return response.json();
            })
            .then(data => {
                console.log('Wishlist data processed:', data);
                if (data.success) {
                    showToast(data.message, 'bg-success');
                    if (data.redirect) {
                        setTimeout(() => {
                            window.location.href = data.redirect;
                        }, 1000);
                    }
                } else {
                    showToast(data.message, 'bg-danger');
                    if (data.redirect) {
                        setTimeout(() => {
                            window.location.href = data.redirect;
                        }, 1000);
                    }
                }
            })
            .catch(error => {
                console.error('Wishlist error:', error);
                showToast('Error processing request', 'bg-danger');
            });
        });
    });
}

// Initialize all forms when the DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('Initializing forms...');
    initializeCartForms();
    initializeWishlistForms();
}); 