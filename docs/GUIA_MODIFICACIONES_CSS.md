# 📋 GUÍA DE MODIFICACIONES CSS - BLOC DE NOTAS

## 🎨 MENÚ SUPERIOR (menu.css) 

### Altura del menú
- **Línea 11**: `height: 40px;` → Cambia la altura de la barra de menú
- **Línea 63**: `height: 40px;` (en .menu-btn) → Altura de cada botón

### Tamaño de fuente del menú
- **Línea 51**: `font-size: 11px;` → Tamaño del texto en los botones del menú

### Espaciado entre botones
- **Línea 48**: `padding: 0 10px;` → Espacio horizontal interno de cada botón (izq/der)

### Tamaño de iconos
- **Línea 77**: `font-size: 14px;` → Tamaño de los emojis/iconos
- **Línea 79**: `margin-right: 4px;` → Espacio entre icono y texto

### Espaciado de texto
- **Línea 86**: `letter-spacing: 0.3px;` → Espaciado entre letras

---

## 📝 FORMULARIO (styles.css)

### Espaciado entre campos (label de abajo e input de arriba)
- **Línea 43**: `margin-bottom: 7px;` → Espacio entre cada grupo label+input
  - **Valor menor** = más cerca
  - **Valor mayor** = más separado

### Altura del contenedor principal
- **Línea 22**: `height: calc(100vh - 40px);` → Altura total (ajusta según altura del menú)

---

## 🏷️ LABELS (Etiquetas)

### Tamaño de fuente del label
- **Línea 129**: `font-size: 12px;` → Tamaño del texto del label

### Espaciado del label respecto al input
- **Línea 132**: `margin-top: 0;` → Margen superior del label
- **Línea 133**: `margin-bottom: 2px;` → Espacio entre label e input (menor = más cerca)

### Interlineado del label
- **Línea 134**: `line-height: 1.2;` → Espaciado entre líneas del texto
  - **1.0** = muy compacto
  - **1.2** = normal
  - **1.5** = más separado

### Ancho de labels en layout horizontal
- **Línea 119**: `min-width: 180px;` → Ancho mínimo del label horizontal
- **Línea 120**: `max-width: 180px;` → Ancho máximo del label horizontal

---

## 📥 INPUTS (Campos de texto)

### Ancho de los inputs
- **Línea 150**: `width: 60%;` → Ancho de todos los inputs
  - **100%** = ancho completo
  - **50%** = medio ancho
  - **300px** = ancho fijo

### Padding interno del input
- **Línea 151**: `padding: 1px 1px;` → Espacio interno (arriba/abajo izq/der)
  - Formato: `padding: vertical horizontal;`
  - Ejemplo: `padding: 4px 8px;` = 4px arriba/abajo, 8px izquierda/derecha

### Tamaño de fuente del input
- **Línea 157**: `font-size: 13px;` → Tamaño del texto dentro del input

### Interlineado del input
- **Línea 159**: `line-height: 1.2;` → Espaciado entre líneas

### Margen superior del input
- **Línea 160**: `margin-top: 0;` → Margen superior (0 = pegado arriba)

### Borde inferior del input
- **Línea 155**: `border-bottom: 1px solid #e0e0e0 !important;`
  - **1px** = grosor de la línea (cambia el número)
  - **solid** = estilo (solid, dashed, dotted)
  - **#e0e0e0** = color (cambia el código hex)

### Proporción del input en layout horizontal
- **Línea 171**: `flex: 1;` → Cuánto espacio ocupa el input (mayor número = más espacio)

---

## 🎨 COLORES Y ESTILOS

### Color del borde al hacer hover
- **Línea 178**: `border-color: #667eea !important;` → Color del borde al pasar el mouse

### Color del borde al hacer focus
- **Línea 186**: `border-color: #667eea !important;` → Color del borde al hacer clic

### Color de fondo al hacer focus
- **Línea 185**: `background: #ffffff;` → Color de fondo del input al hacer clic

---

## 📊 RESUMEN RÁPIDO

| **QUÉ MODIFICAR** | **LÍNEA** | **PROPIEDAD** |
|-------------------|-----------|---------------|
| Espacio entre campos | 43 | `margin-bottom` |
| Tamaño fuente label | 129 | `font-size` |
| Espacio label-input | 133 | `margin-bottom` |
| Tamaño fuente input | 157 | `font-size` |
| Ancho inputs | 150 | `width` |
| Padding inputs | 151 | `padding` |
| Borde inferior | 155 | `border-bottom` |
| Interlineado | 134, 159 | `line-height` |
| Ancho labels horizontal | 119-120 | `min-width`, `max-width` |

---

## 💡 CONSEJOS

- **Para acercar elementos**: Reduce `margin-bottom` o `margin-top`
- **Para separar elementos**: Aumenta `margin-bottom` o `margin-top`
- **Para hacer más compacto**: Reduce `line-height` (ej: 1.0)
- **Para hacer más legible**: Aumenta `line-height` (ej: 1.5)
- **Para cambiar ancho**: Modifica `width` en porcentaje (%) o píxeles (px)

