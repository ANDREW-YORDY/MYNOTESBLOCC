// ===============================================================================
// MODULO PING - Ejecucion asincrona (Compatible IE11)
// ===============================================================================

// POLYFILL para trim() en IE11
if (!String.prototype.trim) {
    String.prototype.trim = function () {
        return this.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');
    };
}

var pingEnEjecucion = false;

function iniciarPing() {

    if (pingEnEjecucion) {
        var cancelar = confirm('Ya hay un ping en ejecucion.\n\nDesea cancelarlo?');
        if (cancelar) {
            document.title = 'CANCELAR_PING';
            var contPinglabel = document.getElementById('contPinglabel');
            if (contPinglabel) {
                contPinglabel.innerHTML = 'Ping cancelado';
                contPinglabel.style.color = '#c50f1f';
                contPinglabel.style.display = 'block';
            }
            pingEnEjecucion = false;
        }
        return;
    }

    // 🔹 CAPTURAR IP DEL INPUT
    var boxPing = document.getElementById('boxPing');
    var ipObjetivo = '';

    if (boxPing && boxPing.value) {
        // Usar replace para limpiar espacios en lugar de trim()
        ipObjetivo = boxPing.value.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, '');

        if (ipObjetivo !== '') {
            // Validación básica de IP (formato xxx.xxx.xxx.xxx)
            var regexIP = /^(\d{1,3}\.){3}\d{1,3}$/;
            if (!regexIP.test(ipObjetivo)) {
                alert('Error: La IP ingresada no es valida.\n\nFormato esperado: xxx.xxx.xxx.xxx\nEjemplo: 192.168.1.1');
                return;
            }

            // Validar rangos (0-255)
            var octetos = ipObjetivo.split('.');
            var ipValida = true;
            for (var i = 0; i < octetos.length; i++) {
                var num = parseInt(octetos[i], 10);
                if (num < 0 || num > 255) {
                    ipValida = false;
                    break;
                }
            }

            if (!ipValida) {
                alert('Error: La IP contiene valores fuera de rango.\n\nCada octeto debe estar entre 0 y 255.');
                return;
            }
        } else {
            // Input vacío
            ipObjetivo = '8.8.8.8';
            alert('No se ingreso una IP.\n\nSe usara 8.8.8.8 (Google DNS) para la prueba.');
        }
    } else {
        // Si el input está vacío o no existe, usar IP de Google por defecto
        ipObjetivo = '8.8.8.8';
        alert('No se ingreso una IP.\n\nSe usara 8.8.8.8 (Google DNS) para la prueba.');
    }

    var confirmacion = confirm('Desea ejecutar ping a ' + ipObjetivo + '?\n\nEsto tomara unos segundos (50 repeticiones).');
    if (!confirmacion) return;

    pingEnEjecucion = true;

    var contPinglabel = document.getElementById('contPinglabel');
    if (contPinglabel) {
        contPinglabel.innerHTML = 'Ejecutando ping a ' + ipObjetivo + '...<br>Consulte la terminal para ver el progreso en tiempo real';
        contPinglabel.style.color = '#000000';
        // contPinglabel.style.color = '#667eea';
        contPinglabel.style.display = 'block';
    }

    // 🔹 ENVIAR IP A AUTOHOTKEY VIA TÍTULO
    document.title = 'EJECUTAR_PING|' + ipObjetivo;
}

function finalizarPing() {
    pingEnEjecucion = false;
}