;===============================================================================
; FORMULARIO WEBVIEW - SISTEMA MODULAR
;===============================================================================
; #Requires AutoHotkey v2.0
; #SingleInstance Force

global navegador := ""
global archivoResultadoPing := ""
global pidBatDemo := 0  ; ← NUEVA LÍNEA (borra si causa problemas)
global pingBloqueado := false  ; ← NUEVA LÍNEA

;-------------------------------------------------------------------------------
; CONFIGURACIÓN DE LA VENTANA - TAMAÑO FIJO
;-------------------------------------------------------------------------------
miVentana := Gui("-Resize -MaximizeBox -MinimizeBox", "Mi bloc")
miVentana.OnEvent("Close", (*) => ExitApp())
miVentana.BackColor := "0xFCFCFC"
miVentana.Show("w420 h670")
miVentana.Opt("+MinSize420x670 +MaxSize420x670")

;-------------------------------------------------------------------------------
; CONTROL WEBVIEW
;-------------------------------------------------------------------------------
wv := miVentana.AddActiveX("x0 y0 w420 h670", "Shell.Explorer")
navegador := wv.Value
navegador.Navigate("about:blank")

while navegador.ReadyState != 4
    Sleep(50)

;-------------------------------------------------------------------------------
; CARGAR TODOS LOS ARCHIVOS DE FORMA MODULAR
;-------------------------------------------------------------------------------
try {
    archivoIndex := A_ScriptDir "\src\view\index.html"
    archivoMenuHTML := A_ScriptDir "\src\components\menu.html"
    archivoMenuCSS := A_ScriptDir "\src\components\menu.css"
    archivoMenuJS := A_ScriptDir "\src\components\menu.js"
    archivoStyles := A_ScriptDir "\src\styles\styles.css"
    archivoScript := A_ScriptDir "\src\scripts\script.js"
    archivoScriptPing := A_ScriptDir "\src\scripts\ping.js"

    if !FileExist(archivoIndex)
        throw Error("Falta index.html")
    if !FileExist(archivoMenuHTML)
        throw Error("Falta menu.html")
    if !FileExist(archivoMenuCSS)
        throw Error("Falta menu.css")
    if !FileExist(archivoMenuJS)
        throw Error("Falta menu.js")
    if !FileExist(archivoStyles)
        throw Error("Falta styles.css")
    if !FileExist(archivoScript)
        throw Error("Falta script.js")
    if !FileExist(archivoScriptPing)
        throw Error("Falta ping.js")

    htmlContent := FileRead(archivoIndex, "UTF-8")
    menuHTML := FileRead(archivoMenuHTML, "UTF-8")
    menuCSS := FileRead(archivoMenuCSS, "UTF-8")
    menuJS := FileRead(archivoMenuJS, "UTF-8")
    cssGlobal := FileRead(archivoStyles, "UTF-8")
    jsFormulario := FileRead(archivoScript, "UTF-8")
    jsPing := FileRead(archivoScriptPing, "UTF-8")

    htmlContent := StrReplace(htmlContent, '<div id="menu-container"></div>', menuHTML)
    if (InStr(htmlContent, menuHTML) = 0)
        htmlContent := StrReplace(htmlContent, '<body>', '<body>' . menuHTML)

    cssCompleto := "<style>" . menuCSS . cssGlobal . "</style>"
    htmlFinal := StrReplace(htmlContent, "</head>", cssCompleto . "</head>")

    jsCompleto := "<script>" . menuJS . jsFormulario . jsPing . "</script>"
    htmlFinal := StrReplace(htmlFinal, "</body>", jsCompleto . "</body>")

    if FileExist(A_ScriptDir "\debug.html")
        FileDelete(A_ScriptDir "\debug.html")
    FileAppend(htmlFinal, A_ScriptDir "\debug.html", "UTF-8")

    navegador.document.write(htmlFinal)
    navegador.document.close()

} catch as err {
    MsgBox("Error: " . err.Message, "Error", 16)
    ExitApp()
}

miVentana.Show("w420 h670")

;-------------------------------------------------------------------------------
; TIMER PARA DETECTAR ENVÍO DE FORMULARIO
;-------------------------------------------------------------------------------
SetTimer(VerificarCambios, 500)

VerificarCambios() {
    global navegador
    try {
        titulo := navegador.document.title
        if (InStr(titulo, "TICKET|") = 1) {
            partes := StrSplit(titulo, "|")
            if (partes.Length >= 7) {
                GuardarTicket(partes[2], partes[3], partes[4], partes[5], partes[6], partes[7])
                navegador.document.title := "Mi bloc"
            }
        }
    }
}

;-------------------------------------------------------------------------------
; FUNCIÓN: GuardarTicket
;-------------------------------------------------------------------------------
GuardarTicket(nombre, telefono, cedula, cuenta, motivo, fecha) {
    lineaCSV := fecha "," nombre "," telefono "," cedula "," cuenta "," motivo "`n"
    archivoTickets := A_ScriptDir "\tickets.csv"

    if !FileExist(archivoTickets)
        FileAppend("Fecha,Nombre,Telefono,Cedula,Cuenta,Motivo`n", archivoTickets, "UTF-8")

    FileAppend(lineaCSV, archivoTickets, "UTF-8")
    MsgBox("Ticket Guardado Exitosamente", "Sistema", 64)
}


;-------------------------------------------------------------------------------
; FUNCIÓN: EjecutarPing - VERSIÓN FINAL CON UTF-8 - ESTA ES LA CORRECTA Y COMPATIBLE
; ;-------------------------------------------------------------------------------
; EjecutarPing() {
;     global navegador
;     try {
;         titulo := navegador.document.title
;         partes := StrSplit(titulo, "|")

;         ipObjetivo := "8.8.8.8"
;         if (partes.Length >= 2 && partes[2] != "") {
;             ipObjetivo := Trim(partes[2])
;         }

;         archivoTemp := A_Temp "\ping_result_" . A_TickCount . ".txt"

;         ; Mostrar mensaje de inicio
;         contPingElem := navegador.document.getElementById("contPinglabel")
;         contPingElem.innerHTML := "Ejecutando ping a " . ipObjetivo . "...<br>50 paquetes (aprox. 50 segundos)<br><br>Por favor espere..."
;         contPingElem.style.color := "#667eea"
;         contPingElem.style.display := "block"

;         ; 🔹 SOLUCIÓN: Forzar UTF-8 con chcp 65001
;         comando := 'cmd.exe /c "chcp 65001 > nul && ping -n 50 ' . ipObjetivo . ' | findstr /C:""Estadísticas"" /C:""Paquetes"" /C:""perdidos"" /C:""Tiempos"" /C:""Mínimo"" > "' . archivoTemp . '""'

;         Run(comando, , "Hide", &PID)

;         global archivoResultadoPing := archivoTemp

;         ; Monitorear el proceso
;         SetTimer(() => VerificarProcesoTerminado(PID), 1000)

;     } catch as err {
;         contPingElem := navegador.document.getElementById("contPinglabel")
;         contPingElem.innerHTML := "ERROR: " . err.Message
;         contPingElem.style.color := "#c50f1f"
;         contPingElem.style.display := "block"

;         try {
;             navegador.document.parentWindow.execScript("finalizarPing();")
;         }
;     }
; }
;-------------------------------------------------------------------------------
; FUNCIÓN: EjecutarPing - CON BLOQUEO DE EJECUCIONES SIMULTÁNEAS
;-------------------------------------------------------------------------------
EjecutarPing() {
    global navegador, pingBloqueado, pidBatDemo

    ; 🔹 BLOQUEAR SI YA HAY UN PING EN EJECUCIÓN
    if (pingBloqueado) {
        MsgBox("Ya hay un ping en ejecución.`n`nDebe esperar a que termine o cancelarlo primero.", "Ping en Ejecución", 48)
        return
    }

    try {
        titulo := navegador.document.title
        partes := StrSplit(titulo, "|")

        ipObjetivo := "8.8.8.8"
        if (partes.Length >= 2 && partes[2] != "") {
            ipObjetivo := Trim(partes[2])
        }

        ; 🔹 ACTIVAR BLOQUEO
        pingBloqueado := true

        ; 🔹 EJECUTAR BAT DE DEMOSTRACIÓN Y GUARDAR SU PID
        rutaBatDemo := A_Desktop "\ping50.bat"
        if FileExist(rutaBatDemo) {
            Run('cmd.exe /k "call "' . rutaBatDemo . '" ' . ipObjetivo . '"', , "", &PIDDemo)
            pidBatDemo := PIDDemo
        }

        archivoTemp := A_Temp "\ping_result_" . A_TickCount . ".txt"

        contPingElem := navegador.document.getElementById("contPinglabel")
        contPingElem.innerHTML := "Ejecutando ping a " . ipObjetivo . "...<br>50 paquetes (aprox. 50 segundos)<br><br>Por favor espere..."
        contPingElem.style.color := "#667eea"
        contPingElem.style.display := "block"

        comando := 'cmd.exe /c "chcp 65001 > nul && ping -n 50 ' . ipObjetivo . ' | findstr /C:""Estadísticas"" /C:""Paquetes"" /C:""perdidos"" /C:""Tiempos"" /C:""Mínimo"" > "' . archivoTemp . '""'

        Run(comando, , "Hide", &PID)

        global archivoResultadoPing := archivoTemp

        SetTimer(() => VerificarProcesoTerminado(PID), 1000)

    } catch as err {
        ; 🔹 DESBLOQUEAR EN CASO DE ERROR
        pingBloqueado := false
        pidBatDemo := 0

        contPingElem := navegador.document.getElementById("contPinglabel")
        contPingElem.innerHTML := "ERROR: " . err.Message
        contPingElem.style.color := "#c50f1f"
        contPingElem.style.display := "block"

        try {
            navegador.document.parentWindow.execScript("finalizarPing();")
        }
    }
}


;--------------------------------------------------------------------------
; FUNCIÓN: VerificarProcesoTerminado - VERSIÓN SIMPLIFICADA
;-------------------------------------------------------------------------------
; VerificarProcesoTerminado(PID) {
;     global navegador, archivoResultadoPing
;     static intentos := 0
;     static ultimoPID := 0

;     if (PID != ultimoPID) {
;         intentos := 0
;         ultimoPID := PID
;     }

;     ; Timeout después de 70 intentos (70 segundos)
;     if (intentos >= 70) {
;         SetTimer(, 0)
;         contPingElem := navegador.document.getElementById("contPinglabel")
;         contPingElem.innerHTML := "Timeout - El ping tardó demasiado.<br>Intente nuevamente o verifique la conexión."
;         contPingElem.style.color := "#c50f1f"
;         contPingElem.style.display := "block"
;         intentos := 0
;         ultimoPID := 0

;         try {
;             navegador.document.parentWindow.execScript("finalizarPing();")
;         }
;         return
;     }

;     procesoActivo := ProcessExist(PID)

;     ; Si el proceso terminó, leer el archivo
;     if (!procesoActivo) {
;         SetTimer(, 0)
;         Sleep(2000)  ; Esperar 2 segundos para asegurar escritura completa

;         if FileExist(archivoResultadoPing) {
;             try {
;                 contenido := FileRead(archivoResultadoPing, "UTF-8")

;                 ; Limpiar el contenido
;                 contenido := StrReplace(contenido, "`r`n", "`n")
;                 contenido := StrReplace(contenido, "`r", "`n")
;                 contenido := Trim(contenido)

;                 contPingElem := navegador.document.getElementById("contPinglabel")

;                 if (StrLen(contenido) > 50) {
;                     ; Convertir saltos de línea a HTML
;                     contenidoHTML := StrReplace(contenido, "`n", "<br>")
;                     contPingElem.innerHTML := contenidoHTML
;                     contPingElem.style.color := "#0f7b0f"
;                 } else {
;                     contPingElem.innerHTML := "Error: Respuesta incompleta del ping.<br><br>Contenido recibido:<br>" . StrReplace(contenido, "`n", "<br>")
;                     contPingElem.style.color := "#c50f1f"
;                 }

;                 contPingElem.style.display := "block"

;                 ; Limpiar archivo temporal
;                 try {
;                     Sleep(500)
;                     FileDelete(archivoResultadoPing)
;                 }

;             } catch as err {
;                 contPingElem := navegador.document.getElementById("contPinglabel")
;                 contPingElem.innerHTML := "Error al leer resultado: " . err.Message
;                 contPingElem.style.color := "#c50f1f"
;                 contPingElem.style.display := "block"
;             }
;         } else {
;             contPingElem := navegador.document.getElementById("contPinglabel")
;             contPingElem.innerHTML := "Error: No se generó el archivo de resultado."
;             contPingElem.style.color := "#c50f1f"
;             contPingElem.style.display := "block"
;         }

;         intentos := 0
;         ultimoPID := 0

;         try {
;             navegador.document.parentWindow.execScript("finalizarPing();")
;         }
;         return
;     }

;     ; Actualizar progreso cada 10 segundos
;     if (Mod(intentos, 10) = 0 && intentos > 0) {
;         contPingElem := navegador.document.getElementById("contPinglabel")
;         contPingElem.innerHTML := "Ping en progreso... (" . intentos . " segundos)<br>Esperando finalización..."
;         contPingElem.style.color := "#667eea"
;         contPingElem.style.display := "block"
;     }

;     intentos++
; }
;-------------------------------------------------------------------------------
; FUNCIÓN: VerificarProcesoTerminado - VERSIÓN OPTIMIZADA
;-------------------------------------------------------------------------------
VerificarProcesoTerminado(PID) {
    global navegador, archivoResultadoPing
    static intentos := 0
    static ultimoPID := 0

    ; Reiniciar contador si es un nuevo PID
    if (PID != ultimoPID) {
        intentos := 0
        ultimoPID := PID
    }

    ; Timeout después de 70 intentos (70 segundos)
    if (intentos >= 70) {
        SetTimer(, 0)
        contPingElem := navegador.document.getElementById("contPinglabel")
        contPingElem.innerHTML := "Timeout - El ping tardó demasiado.<br>Intente nuevamente o verifique la conexión."
        contPingElem.style.color := "#c50f1f"
        contPingElem.style.display := "block"
        intentos := 0
        ultimoPID := 0

        try {
            navegador.document.parentWindow.execScript("finalizarPing();")
        }
        return
    }

    procesoActivo := ProcessExist(PID)

    ; ✅ OPTIMIZACIÓN: Si el proceso terminó, leer INMEDIATAMENTE
    if (!procesoActivo) {
        SetTimer(, 0)

        ; 🔹 Reducido de 2000ms a 500ms
        Sleep(500)

        if FileExist(archivoResultadoPing) {
            try {
                contenido := FileRead(archivoResultadoPing, "UTF-8")

                ; Limpiar el contenido
                contenido := StrReplace(contenido, "`r`n", "`n")
                contenido := StrReplace(contenido, "`r", "`n")
                contenido := Trim(contenido)

                contPingElem := navegador.document.getElementById("contPinglabel")

                ; 🔹 Validación más flexible (mínimo 50 caracteres)
                if (StrLen(contenido) > 50) {
                    ; Convertir saltos de línea a HTML
                    contenidoHTML := StrReplace(contenido, "`n", "<br>")
                    contPingElem.innerHTML := contenidoHTML
                    contPingElem.style.color := "#0f7b0f"
                } else {
                    contPingElem.innerHTML := "Error: Respuesta incompleta del ping.<br><br>Contenido recibido:<br>" . StrReplace(contenido, "`n", "<br>")
                    contPingElem.style.color := "#c50f1f"
                }

                contPingElem.style.display := "block"

                ; Limpiar archivo temporal
                try {
                    ; 🔹 Reducido de 500ms a 200ms
                    Sleep(200)
                    FileDelete(archivoResultadoPing)
                }

            } catch as err {
                contPingElem := navegador.document.getElementById("contPinglabel")
                contPingElem.innerHTML := "Error al leer resultado: " . err.Message
                contPingElem.style.color := "#c50f1f"
                contPingElem.style.display := "block"
            }
        } else {
            contPingElem := navegador.document.getElementById("contPinglabel")
            contPingElem.innerHTML := "Error: No se generó el archivo de resultado."
            contPingElem.style.color := "#c50f1f"
            contPingElem.style.display := "block"
        }

        intentos := 0
        ultimoPID := 0

        ; 🔹 DESBLOQUEAR PING
        global pingBloqueado := false
        global pidBatDemo := 0

        try {
            navegador.document.parentWindow.execScript("finalizarPing();")
        }
        return
    }

    ; ✅ OPTIMIZACIÓN: Mostrar progreso cada 10 segundos (antes era cada 10)
    if (Mod(intentos, 10) = 0 && intentos > 0) {
        contPingElem := navegador.document.getElementById("contPinglabel")
        contPingElem.innerHTML := "Ping en progreso... (" . intentos . " segundos)<br>Esperando finalización..."
        contPingElem.style.color := "#667eea"
        contPingElem.style.display := "block"
    }

    intentos++
}


;-------------------------------------------------------------------------------
; TIMER: Detectar señal de ping
;-------------------------------------------------------------------------------
VerificarPing() {
    global navegador
    try {
        titulo := navegador.document.title
        if (InStr(titulo, "EJECUTAR_PING") = 1) {
            EjecutarPing()
            navegador.document.title := "Mi bloc"
        }
    }
}

SetTimer(VerificarPing, 500)

;-------------------------------------------------------------------------------
; FUNCIÓN: CancelarPing - VERSIÓN SIMPLIFICADA - INICIAL Y FUNCIONAL
;-------------------------------------------------------------------------------
; CancelarPing() {
;     global navegador, archivoResultadoPing
;     try {
;         ; Detener timer
;         SetTimer(VerificarProcesoTerminado, 0)

;         ; Matar procesos
;         Run("taskkill /F /IM cmd.exe", , "Hide")
;         Run("taskkill /F /IM PING.EXE", , "Hide")

;         ; Limpiar archivo temporal
;         if FileExist(archivoResultadoPing) {
;             try {
;                 Sleep(500)
;                 FileDelete(archivoResultadoPing)
;             }
;         }

;         ; Mostrar mensaje
;         contPingElem := navegador.document.getElementById("contPinglabel")
;         contPingElem.innerHTML := "Ping cancelado por el usuario"
;         contPingElem.style.color := "#c50f1f"
;         contPingElem.style.display := "block"

;         try {
;             navegador.document.parentWindow.execScript("finalizarPing();")
;         }
;     }
; }
;-------------------------------------------------------------------------------
; FUNCIÓN: CancelarPing - SOLUCIÓN DEFINITIVA
;-------------------------------------------------------------------------------
CancelarPing() {
    global navegador, archivoResultadoPing, pidBatDemo, pingBloqueado
    try {
        ; Detener timer
        SetTimer(VerificarProcesoTerminado, 0)

        ; 🔹 MATAR PROCESO ESPECÍFICO DEL BAT
        if (pidBatDemo != 0) {
            Run("taskkill /F /PID " . pidBatDemo, , "Hide")
            Sleep(300)
            pidBatDemo := 0
        }

        ; 🔹 MATAR TODOS LOS CMD QUE TENGAN "Ping" EN EL TÍTULO
        Run('taskkill /F /FI "WINDOWTITLE eq *Ping*" /IM cmd.exe', , "Hide")
        Sleep(300)

        ; 🔹 MATAR TODOS LOS PROCESOS PING.EXE
        Run("taskkill /F /IM PING.EXE", , "Hide")
        Sleep(300)

        ; 🔥 OPCIÓN NUCLEAR: Matar TODOS los CMD (úsala solo si lo anterior falla) -> (ELIMINAR SI FALLA)
        Run("taskkill /F /IM cmd.exe", , "Hide")

        ; 🔹 DESBLOQUEAR
        pingBloqueado := false

        ; Limpiar archivo temporal
        if FileExist(archivoResultadoPing) {
            try {
                FileDelete(archivoResultadoPing)
            }
        }

        ; Mostrar mensaje
        contPingElem := navegador.document.getElementById("contPinglabel")
        contPingElem.innerHTML := "Ping cancelado - Todos los procesos terminados"
        contPingElem.style.color := "#c50f1f"
        contPingElem.style.display := "block"

        try {
            navegador.document.parentWindow.execScript("finalizarPing();")
        }
    }
}

;-------------------------------------------------------------------------------
; TIMER: Detectar cancelación
;-------------------------------------------------------------------------------
VerificarCancelacion() {
    global navegador
    try {
        titulo := navegador.document.title
        if (InStr(titulo, "CANCELAR_PING") = 1) {
            CancelarPing()
            navegador.document.title := "Mi bloc"
        }
    }
}

SetTimer(VerificarCancelacion, 500)

;-------------------------------------------------------------------------------
; HOTKEYS
;-------------------------------------------------------------------------------
#HotIf WinActive("Mi bloc")
Enter::
{
    try {
        activeId := navegador.document.activeElement.id

        siguiente := Map(
            "nombre", "cedula",
            "cedula", "telefono",
            "telefono", "cuenta",
            "cuenta", "repetitivo",
            "repetitivo", "garantia",
            "garantia", "masivo",
            "masivo", "riesgo",
            "riesgo", "telecable",
            "telecable", "motivo"
        )

        if siguiente.Has(activeId) {
            navegador.document.getElementById(siguiente[activeId]).focus()
        } else if (activeId = "motivo") {
            navegador.document.getElementById("ticketForm").submit()
        }
    }
}

^c::
{
    try {
        activeTag := navegador.document.activeElement.tagName
        if (activeTag = "INPUT" || activeTag = "TEXTAREA") {
            navegador.document.execCommand("copy")
        }
    }
}

^v::
{
    try {
        activeTag := navegador.document.activeElement.tagName
        if (activeTag = "INPUT" || activeTag = "TEXTAREA") {
            clipboardData := A_Clipboard
            navegador.document.activeElement.value := navegador.document.activeElement.value . clipboardData
        }
    }
}

^x::
{
    try {
        activeTag := navegador.document.activeElement.tagName
        if (activeTag = "INPUT" || activeTag = "TEXTAREA") {
            navegador.document.execCommand("cut")
        }
    }
}

^a::
{
    try {
        activeTag := navegador.document.activeElement.tagName
        if (activeTag = "INPUT" || activeTag = "TEXTAREA") {
            navegador.document.activeElement.select()
        }
    }
}
#HotIf


; MsgBox("Sistema de ping actualizado correctamente")
