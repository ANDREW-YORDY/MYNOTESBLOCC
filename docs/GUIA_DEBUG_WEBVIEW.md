# 🔍 GUÍA: DEBUG EN WEBVIEW (AutoHotkey)

## ⚠️ PROBLEMA

Cuando usas **WebView (Shell.Explorer)** en AutoHotkey, las herramientas de desarrollo de IE11 **NO están disponibles** de la misma manera que en un navegador normal.

---

## ✅ SOLUCIONES ALTERNATIVAS

### **MÉTODO 1: Guardar HTML generado (RECOMENDADO)**

Modifica temporalmente `app.ahk` para guardar el HTML final y abrirlo en IE11:

```autohotkey
; Después de la línea donde se genera htmlFinal, agrega:
FileDelete(A_ScriptDir "\debug.html")
FileAppend(htmlFinal, A_ScriptDir "\debug.html", "UTF-8")
```

**Pasos:**
1. Agrega esas líneas en `app.ahk`
2. Ejecuta la aplicación
3. Abre `debug.html` directamente en IE11
4. Ahora SÍ puedes usar F12 normalmente

---

### **MÉTODO 2: Ver HTML en consola de AutoHotkey**

Agrega esto temporalmente para ver el HTML generado:

```autohotkey
; Después de generar htmlFinal
MsgBox("HTML generado. Revisa la consola.")
FileAppend(htmlFinal, A_ScriptDir "\debug.html", "UTF-8")
Run("notepad.exe " . A_ScriptDir . "\debug.html")
```

Esto abrirá el HTML en Notepad para que lo veas.

---

### **MÉTODO 3: Verificar con JavaScript inline**

Agrega esto temporalmente en el HTML para verificar:

```javascript
// Al final de menu.js, agrega:
setTimeout(function() {
    var svgs = document.querySelectorAll('.menu-icon svg');
    alert('SVGs encontrados: ' + svgs.length);
    for (var i = 0; i < svgs.length; i++) {
        console.log('SVG ' + i + ':', svgs[i].offsetWidth, 'x', svgs[i].offsetHeight);
    }
}, 1000);
```

---

### **MÉTODO 4: Agregar borde temporal para verificar**

Modifica `menu.css` temporalmente:

```css
.menu-icon {
    border: 2px solid red !important;  /* Temporal para verificar */
    background: yellow !important;     /* Temporal para verificar */
}
```

Si ves un cuadro rojo/amarillo, el contenedor está ahí pero el SVG no se ve.

---

### **MÉTODO 5: Usar alert() para depuración**

Agrega esto en `menu.js`:

```javascript
// Al inicio de inicializarMenu(), agrega:
var testSVG = document.querySelector('.menu-icon svg');
if (testSVG) {
    alert('SVG encontrado! Ancho: ' + testSVG.offsetWidth);
} else {
    alert('SVG NO encontrado en el DOM');
}
```

---

## 🎯 MÉTODO RECOMENDADO: Guardar HTML

**Modifica `app.ahk` así:**

```autohotkey
; Busca esta línea (alrededor de línea 81):
htmlFinal := StrReplace(htmlFinal, "</body>", todosLosJS . "`n</body>")

; Agrega DESPUÉS de esa línea:
; ═══════════════════════════════════════════════════════════
; DEBUG: Guardar HTML para inspección
; ═══════════════════════════════════════════════════════════
FileDelete(A_ScriptDir "\debug.html")
FileAppend(htmlFinal, A_ScriptDir "\debug.html", "UTF-8")
```

**Luego:**
1. Ejecuta `app.ahk`
2. Abre `debug.html` en IE11 (doble clic)
3. Ahora SÍ puedes usar F12 normalmente
4. Inspecciona los elementos como se describe en `GUIA_DEBUG_IE11.md`

---

## 🔍 VERIFICACIÓN RÁPIDA SIN HERRAMIENTAS

### **Verificar si el SVG está en el código fuente:**

1. Abre `src/components/menu.html` en un editor de texto
2. Busca `<svg` - deberías encontrar 4 ocurrencias
3. Verifica que cada SVG tenga:
   - `width="16" height="16"`
   - `viewBox="0 0 24 24"`
   - Un elemento `<path>` con `fill="#COLOR"`

### **Verificar si AutoHotkey está cargando el archivo:**

Agrega esto temporalmente en `app.ahk`:

```autohotkey
menuHTML := FileRead(A_ScriptDir "\src\components\menu.html", "UTF-8")
if (InStr(menuHTML, "<svg") > 0) {
    MsgBox("✅ SVG encontrado en menu.html")
} else {
    MsgBox("❌ SVG NO encontrado en menu.html")
}
```

---

## 🚨 PROBLEMA COMÚN: WebView no renderiza SVG

Si el SVG está en el HTML pero no se ve, puede ser que:

1. **WebView tiene limitaciones con SVG inline**
2. **Necesitas usar data URI en lugar de SVG inline**

### **Solución alternativa: Usar data URI**

En lugar de SVG inline, usa background-image con data URI:

```css
.menu-icon {
    width: 16px;
    height: 16px;
    background-image: url('data:image/svg+xml;utf8,<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z" fill="%234A90E2"/></svg>');
    background-repeat: no-repeat;
    background-position: center;
}
```

---

## ✅ CHECKLIST DE VERIFICACIÓN

- [ ] Verificar que `menu.html` contiene los SVG
- [ ] Guardar HTML generado con el método 1
- [ ] Abrir `debug.html` en IE11
- [ ] Usar F12 en IE11 (ahora sí funciona)
- [ ] Verificar SVG en el DOM
- [ ] Si no funciona, probar data URI

---

## 💡 PRÓXIMOS PASOS

1. **Primero**: Usa el MÉTODO 1 (guardar HTML)
2. **Segundo**: Abre `debug.html` en IE11
3. **Tercero**: Ahora sí puedes usar F12
4. **Cuarto**: Comparte lo que ves en el DOM Explorer

