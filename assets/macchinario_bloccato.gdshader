shader_type canvas_item;

void fragment() {
    // Prende il colore originale del pixel dell'immagine
    vec4 colore_originale = texture(TEXTURE, UV);
    
    // Calcola la media dei colori per trovare il grigio (luminosità)
    float grigio = dot(colore_originale.rgb, vec3(0.299, 0.587, 0.114));
    
    // Imposta il colore finale: R, G e B sono uguali (grigio), mantenendo la trasparenza originale
    COLOR = vec4(grigio, grigio, grigio, colore_originale.a);
}