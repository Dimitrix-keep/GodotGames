shader_type canvas_item;

uniform float velocidad_flujo : hint_range(0.0, 1.0) = 0.1;
uniform float amplitud_onda : hint_range(0.0, 0.1) = 0.02;
uniform float frecuencia_onda : hint_range(0.0, 50.0) = 12.0;
uniform vec4 color_tinte : source_color = vec4(0.0, 0.4, 0.6, 0.7);
uniform float brillo_superficie : hint_range(0.0, 1.0) = 0.3;

void fragment() {
    vec2 uv = UV;
    
    // 1. Movimiento de la superficie (Ondulación 2D)
    // Usamos el seno para crear el movimiento de subida y bajada
    float tiempo = TIME * 2.0;
    float mascara_onda = smoothstep(0.4, 0.0, uv.y); // Solo afecta al borde superior
    float distorsion = sin(uv.x * frecuencia_onda + tiempo) * amplitud_onda * mascara_onda;
    
    // Aplicamos la distorsión al eje Y
    uv.y += distorsion;
    
    // 2. Desplazamiento horizontal continuo (Scrolling)
    uv.x = fract(uv.x + TIME * velocidad_flujo);
    
    // 3. Renderizado de color
    vec4 tex_color = texture(TEXTURE, uv);
    
    // Mezclamos el color del sprite con un tinte de agua
    vec4 color_final = mix(tex_color, color_tinte, 0.5);
    
    // 4. Efecto de "Borde de Espuma" (Brillo en la cresta)
    // Si el píxel está muy cerca del borde superior después de la onda, lo aclaramos
    float borde = smoothstep(0.1, 0.0, uv.y + distorsion);
    color_final.rgb += borde * brillo_superficie;
    
    // Transparencia global para ver la arena debajo
    color_final.a = color_tinte.a;
    
    COLOR = color_final;
}