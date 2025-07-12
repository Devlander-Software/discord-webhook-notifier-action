// Discord Notify Action Documentation JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Highlight current page in navigation
    const currentPath = window.location.pathname;
    document.querySelectorAll('.list-group-item').forEach(item => {
        const href = item.getAttribute('href');
        if (href && currentPath.includes(href.replace('.html', ''))) {
            item.classList.add('active');
        }
    });

    // Copy code blocks
    document.querySelectorAll('pre code').forEach(block => {
        const button = document.createElement('button');
        button.className = 'btn btn-sm btn-outline-secondary copy-btn';
        button.textContent = 'Copy';
        button.style.position = 'absolute';
        button.style.top = '0.5rem';
        button.style.right = '0.5rem';
        
        const wrapper = document.createElement('div');
        wrapper.style.position = 'relative';
        wrapper.appendChild(button);
        block.parentNode.insertBefore(wrapper, block);
        wrapper.appendChild(block);
        
        button.addEventListener('click', async () => {
            try {
                await navigator.clipboard.writeText(block.textContent);
                button.textContent = 'Copied!';
                button.classList.remove('btn-outline-secondary');
                button.classList.add('btn-success');
                setTimeout(() => {
                    button.textContent = 'Copy';
                    button.classList.remove('btn-success');
                    button.classList.add('btn-outline-secondary');
                }, 2000);
            } catch (err) {
                console.error('Failed to copy: ', err);
            }
        });
    });

    // Search functionality
    const searchInput = document.getElementById('search-input');
    if (searchInput) {
        searchInput.addEventListener('input', function() {
            const query = this.value.toLowerCase();
            const items = document.querySelectorAll('.list-group-item');
            
            items.forEach(item => {
                const text = item.textContent.toLowerCase();
                if (text.includes(query)) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        });
    }

    // Mobile menu toggle
    const navbarToggler = document.querySelector('.navbar-toggler');
    const navbarCollapse = document.querySelector('.navbar-collapse');
    
    if (navbarToggler && navbarCollapse) {
        navbarToggler.addEventListener('click', function() {
            navbarCollapse.classList.toggle('show');
        });
    }

    // Auto-hide alerts after 5 seconds
    document.querySelectorAll('.alert').forEach(alert => {
        setTimeout(() => {
            if (alert.classList.contains('alert-dismissible')) {
                const closeBtn = alert.querySelector('.btn-close');
                if (closeBtn) {
                    closeBtn.click();
                }
            }
        }, 5000);
    });

    // Table of contents
    const toc = document.getElementById('table-of-contents');
    if (toc) {
        const headings = document.querySelectorAll('h2, h3, h4');
        const tocList = document.createElement('ul');
        tocList.className = 'list-unstyled';
        
        headings.forEach(heading => {
            const id = heading.textContent.toLowerCase().replace(/[^a-z0-9]+/g, '-');
            heading.id = id;
            
            const link = document.createElement('a');
            link.href = `#${id}`;
            link.textContent = heading.textContent;
            link.className = `toc-link ${heading.tagName.toLowerCase()}`;
            
            const listItem = document.createElement('li');
            listItem.appendChild(link);
            tocList.appendChild(listItem);
        });
        
        toc.appendChild(tocList);
    }

    // Syntax highlighting for YAML
    document.querySelectorAll('pre code.language-yaml').forEach(block => {
        // Basic YAML syntax highlighting
        let html = block.innerHTML;
        html = html.replace(/(\w+):/g, '<span class="yaml-key">$1:</span>');
        html = html.replace(/(\d+)/g, '<span class="yaml-number">$1</span>');
        html = html.replace(/(true|false)/g, '<span class="yaml-boolean">$1</span>');
        html = html.replace(/(#.*)/g, '<span class="yaml-comment">$1</span>');
        block.innerHTML = html;
    });

    // Performance monitoring
    if ('performance' in window) {
        window.addEventListener('load', function() {
            const loadTime = performance.timing.loadEventEnd - performance.timing.navigationStart;
            console.log(`Page loaded in ${loadTime}ms`);
        });
    }
});

// Service Worker for offline support
if ('serviceWorker' in navigator) {
    window.addEventListener('load', function() {
        navigator.serviceWorker.register('/sw.js')
            .then(function(registration) {
                console.log('SW registered: ', registration);
            })
            .catch(function(registrationError) {
                console.log('SW registration failed: ', registrationError);
            });
    });
} 