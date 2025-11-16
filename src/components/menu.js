// ===============================================================================
// LOGICA DEL MENU - COMPONENTE REUTILIZABLE (Compatible IE11)
// ===============================================================================

(function () {
    function inicializarMenu() {
        var btnArchivo = document.getElementById('btn-archivo');
        var btnOpciones = document.getElementById('btn-opciones');
        var btnLimpiar = document.getElementById('btn-limpiar');
        var btnCopiar = document.getElementById('btn-copiar');
        var btnPing = document.getElementById('btn-ping');

        if (btnArchivo) {
            btnArchivo.onclick = menuArchivo;
        }
        if (btnOpciones) {
            btnOpciones.onclick = menuOpciones;
        }
        if (btnLimpiar) {
            btnLimpiar.onclick = menuLimpiar;
        }
        if (btnCopiar) {
            btnCopiar.onclick = menuCopiar;
        }
        if (btnPing) {
            btnPing.onclick = menuPing;
        }
    }

    if (document.readyState === 'loading') {
        if (document.addEventListener) {
            document.addEventListener('DOMContentLoaded', inicializarMenu);
        } else if (document.attachEvent) {
            document.attachEvent('onreadystatechange', function () {
                if (document.readyState === 'complete') {
                    inicializarMenu();
                }
            });
        }
    } else {
        inicializarMenu();
    }
})();

function menuArchivo() {
    alert('Menu Archivo - Funcionalidad en desarrollo');
}

function menuOpciones() {
    alert('Menu Opciones - Funcionalidad en desarrollo');
}

function menuLimpiar() {
    var confirmacion = confirm('Esta seguro de que desea limpiar todos los campos?\n\nSe perderan todos los datos ingresados.');
    if (confirmacion) {
        var formulario = document.getElementById('ticketForm');
        if (formulario) {
            formulario.reset();

            // Limpiar input del ping
            var boxPing = document.getElementById('boxPing');
            if (boxPing) {
                boxPing.value = '';
                boxPing.style.color = '#2e2e2e';
            }

            // Limpiar contenedor de estadísticas del ping
            var contPinglabel = document.getElementById('contPinglabel');
            if (contPinglabel) {
                contPinglabel.innerHTML = '';
                contPinglabel.style.color = 'black';
                contPinglabel.style.display = 'none';
            }

            // Resetear select a primera opción
            var select = document.getElementById('select');
            if (select && select.options.length > 0) {
                select.selectedIndex = 0;
            }

            alert('Formulario limpiado correctamente');
        }
    }
}

function menuCopiar() {
    try {
        var nombre = document.getElementById('nombre');
        var cedula = document.getElementById('cedula');
        var telefono = document.getElementById('telefono');
        var cuenta = document.getElementById('cuenta');

        var texto = 'DATOS DEL FORMULARIO\n';
        texto = texto + '===========================\n';
        texto = texto + 'Nombre: ' + (nombre ? nombre.value : '') + '\n';
        texto = texto + 'Cedula: ' + (cedula ? cedula.value : '') + '\n';
        texto = texto + 'Telefono: ' + (telefono ? telefono.value : '') + '\n';
        texto = texto + 'Cuenta: ' + (cuenta ? cuenta.value : '') + '\n';

        if (window.clipboardData && window.clipboardData.setData) {
            window.clipboardData.setData('Text', texto);
            alert('Datos copiados al portapapeles');
        } else {
            alert('Copie estos datos:\n\n' + texto);
        }
    } catch (error) {
        alert('Error al copiar: ' + error.message);
    }
}

function menuPing() {
    iniciarPing();
}

function copiarEstadisticasPing() {
    var contPinglabel = document.getElementById('contPinglabel');
    var textoTemp = contPinglabel ? contPinglabel.innerText : '';
    // Limpiar espacios sin usar trim()
    textoTemp = textoTemp.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');

    if (!contPinglabel || !textoTemp || textoTemp === '') {
        alert('No hay estadisticas para copiar');
        return;
    }

    var texto = contPinglabel.innerText;

    if (window.clipboardData && window.clipboardData.setData) {
        window.clipboardData.setData('Text', texto);

        var notif = document.getElementById('copyNotification');
        if (notif) {
            notif.innerHTML = 'Estadisticas copiadas';
            notif.style.background = '#0f7b0f';
            notif.style.display = 'block';
        }
    } else {
        alert('Estadisticas copiadas:\n\n' + texto);
    }
}