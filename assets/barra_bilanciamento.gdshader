shader_type canvas_item;

// Colore del contorno (di base è bianco)
uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
// Spessore del contorno (puoi regolarlo nell'Inspector)
uniform float line_thickness : hint_range(0.0, 10.0) = 1.0;

void fragment() {
    vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;

    // Controlla i pixel circostanti per trovare il bordo
    float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
    outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
    outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
    outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
    outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;

    // Assicura che il valore sia tra 0 e 1
    outline = min(outline, 1.0);

    // Prende il colore originale del pixel
    vec4 color = texture(TEXTURE, UV);

    // Se il pixel è trasparente ma siamo su un bordo, applica il colore del contorno
    // Altrimenti usa il colore originale dell'immagine
    COLOR = mix(color, line_color, outline - color.a);
}