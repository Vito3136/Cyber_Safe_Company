shader_type canvas_item;

// Queste variabili appariranno nell'Inspector
uniform vec2 center = vec2(0.5, 0.5); // Posizione del buco (0.0 a 1.0)
uniform vec2 size = vec2(0.2, 0.2);   // Grandezza del buco

void fragment() {
    // Prendiamo le coordinate UV (da 0 a 1)
    vec2 uv = UV;
    
    // Calcoliamo i confini del rettangolo trasparente
    bool in_x = uv.x > (center.x - size.x / 2.0) && uv.x < (center.x + size.x / 2.0);
    bool in_y = uv.y > (center.y - size.y / 2.0) && uv.y < (center.y + size.y / 2.0);
    
    // Se siamo dentro il rettangolo, rendiamo il pixel trasparente
    if (in_x && in_y) {
        COLOR.a = 0.0;
    }
}