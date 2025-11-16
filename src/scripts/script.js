var copiando = false;

var copiando = false;

function copiarValor(inputId) {
    if (copiando) return false;
    copiando = true;

    var input = document.getElementById(inputId);
    if (!input) {
        copiando = false;
        return false;
    }

    var valor = input.value;
    if (!valor) {
        var notif = document.getElementById('copyNotification');
        if (notif) {
            notif.innerHTML = 'Campo vacio';
            notif.style.background = '#c50f1f';
            notif.style.display = 'block';
        }
        copiando = false;
        return false;
    }

    input.select();
    document.execCommand('copy');

    var label = input.parentNode.getElementsByTagName('label')[0];
    var nombreCampo = label ? label.innerText.replace(':', '') : 'Valor';

    var notif = document.getElementById('copyNotification');
    if (notif) {
        notif.innerHTML = nombreCampo + ' copiado';
        notif.style.background = '#0f7b0f';
        notif.style.display = 'block';
    }

    copiando = false;
    return false;
}

function irAlSiguiente(actualId, siguienteId) {
    var actual = document.getElementById(actualId);
    if (!actual) return;

    actual.onkeydown = function (e) {
        e = e || window.event;
        var tecla = e.keyCode || e.which;

        if (tecla === 13 || tecla === 9) {
            e.returnValue = false;
            e.cancelBubble = true;

            if (siguienteId) {
                var siguiente = document.getElementById(siguienteId);
                if (siguiente) {
                    siguiente.focus();
                }
            } else {
                enviarFormulario();
            }
            return false;
        }
    };
}

irAlSiguiente('nombre', 'cedula');
irAlSiguiente('cedula', 'telefono');
irAlSiguiente('telefono', 'cuenta');
irAlSiguiente('cuenta', 'repetitivo');
irAlSiguiente('repetitivo', 'garantia');
irAlSiguiente('garantia', 'masivo');
irAlSiguiente('masivo', 'riesgo');
irAlSiguiente('riesgo', 'telecable');
irAlSiguiente('telecable', 'motivo');
irAlSiguiente('motivo', null);

function enviarFormulario() {
    var nombre = document.getElementById('nombre').value;
    var telefono = document.getElementById('telefono').value;
    var cedula = document.getElementById('cedula').value;
    var cuenta = document.getElementById('cuenta').value;
    var motivo = document.getElementById('motivo').value;
    var estPing = document.getElementById('estping').value;

    var d = new Date();
    var fecha = d.getDate() + '-' + (d.getMonth() + 1) + '-' + d.getFullYear();

    document.title = 'TICKET|' + nombre + '|' + telefono + '|' + cedula + '|' + cuenta + '|' + motivo + '|' + fecha;

    var msg = document.getElementById('successMsg');
    if (msg) msg.style.display = 'block';

    var f = document.getElementById('ticketForm');
    if (f) f.reset();

    return false;
}


setInterval(function () {
    var notif = document.getElementById('copyNotification');
    if (notif && notif.style.display === 'block') {
        notif.style.display = 'none';
    }
}, 2000);