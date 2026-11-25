// Smooth VS Code-like cursor glide & gentle Kitty-style tail shader for Ghostty
// Slower, silky easeOutQuart deceleration with soft Catppuccin Lavender fade.

const float DURATION = 0.26;       // Smooth, deliberate glide (260ms like VS Code smooth caret)
const float TRAIL_OPACITY = 0.50;  // Gentle, eye-friendly translucency

float easeOutQuart(float x) {
    return 1.0 - pow(1.0 - x, 4.0);
}

vec2 toNorm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float getSdfQuad(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    vec2 v[4] = vec2[4](v0, v1, v2, v3);
    float d = dot(p - v[0], p - v[0]);
    float s = 1.0;
    for (int i = 0, j = 3; i < 4; j = i, i++) {
        vec2 e = v[j] - v[i];
        vec2 w = p - v[i];
        vec2 b = w - e * clamp(dot(w, e) / max(dot(e, e), 1e-8), 0.0, 1.0);
        d = min(d, dot(b, b));
        bvec3 c = bvec3(p.y >= v[i].y, p.y < v[j].y, e.x * w.y > e.y * w.x);
        if (all(c) || all(not(c))) s *= -1.0;
    }
    return s * sqrt(d);
}

float getSdfRect(in vec2 p, in vec2 xy, in vec2 wh) {
    vec2 center = vec2(xy.x + wh.x * 0.5, xy.y - wh.y * 0.5);
    vec2 d = abs(p - center) - wh * 0.5;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// 1.0 for leading corners, 0.0 for trailing corners
float vertexFactor(vec2 offsetFromCenter, vec2 moveDir) {
    return dot(normalize(offsetFromCenter), moveDir) > 0.0 ? 1.0 : 0.0;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec2 texCoord = fragCoord / iResolution.xy;
    fragColor = texture(iChannel0, texCoord);

    // Idle or unfocused: pure original terminal output
    float elapsed = iTime - iTimeCursorChange;
    if (iFocus == 0 || elapsed < 0.0 || elapsed >= DURATION ||
        iCurrentCursor.zw == vec2(0.0) || iPreviousCursor.zw == vec2(0.0)) {
        return;
    }

    vec4 curr = vec4(toNorm(iCurrentCursor.xy, 1.0), toNorm(iCurrentCursor.zw, 0.0));
    vec4 prev = vec4(toNorm(iPreviousCursor.xy, 1.0), toNorm(iPreviousCursor.zw, 0.0));

    vec2 currCenter = vec2(curr.x + curr.z * 0.5, curr.y - curr.w * 0.5);
    vec2 prevCenter = vec2(prev.x + prev.z * 0.5, prev.y - prev.w * 0.5);

    float moveDist = distance(currCenter, prevCenter);
    if (moveDist < 0.001) {
        return;
    }

    vec2 uv = toNorm(fragCoord, 1.0);
    vec2 moveDir = (currCenter - prevCenter) / moveDist;
    float progress = clamp(elapsed / DURATION, 0.0, 1.0);

    // Gentle VS Code-like deceleration for both leading and trailing edges
    float leadEase  = easeOutQuart(min(1.0, progress * 1.25));
    float trailEase = easeOutQuart(progress * 0.75);

    vec2 c0 = vec2(curr.x,          curr.y);
    vec2 c1 = vec2(curr.x + curr.z, curr.y);
    vec2 c2 = vec2(curr.x + curr.z, curr.y - curr.w);
    vec2 c3 = vec2(curr.x,          curr.y - curr.w);

    vec2 p0 = vec2(prev.x,          prev.y);
    vec2 p1 = vec2(prev.x + prev.z, prev.y);
    vec2 p2 = vec2(prev.x + prev.z, prev.y - prev.w);
    vec2 p3 = vec2(prev.x,          prev.y - prev.w);

    vec2 v0 = mix(p0, c0, mix(trailEase, leadEase, vertexFactor(c0 - currCenter, moveDir)));
    vec2 v1 = mix(p1, c1, mix(trailEase, leadEase, vertexFactor(c1 - currCenter, moveDir)));
    vec2 v2 = mix(p2, c2, mix(trailEase, leadEase, vertexFactor(c2 - currCenter, moveDir)));
    vec2 v3 = mix(p3, c3, mix(trailEase, leadEase, vertexFactor(c3 - currCenter, moveDir)));

    float sdfTrail = getSdfQuad(uv, v0, v1, v2, v3);
    float sdfCurr  = getSdfRect(uv, curr.xy, curr.zw);

    float aa = 1.5 / iResolution.y;
    float currMask  = 1.0 - smoothstep(-aa, aa, sdfCurr);
    float trailMask = (1.0 - smoothstep(-aa, aa, sdfTrail)) * (1.0 - currMask);

    if (trailMask <= 0.001) {
        return;
    }

    // Soft transition: Cursor (#cdd6f4) -> Lavender (#b4befe)
    float tailT = clamp(dot(currCenter - uv, moveDir) / max(moveDist, 1e-5), 0.0, 1.0);
    vec3 trailColor = mix(iCurrentCursorColor.rgb, iPalette[12], smoothstep(0.0, 0.9, tailT));

    float spatialFade = 1.0 - tailT * 0.55;
    float timeFade = 1.0 - progress * 0.65;
    float alpha = trailMask * TRAIL_OPACITY * spatialFade * timeFade;

    fragColor.rgb = mix(fragColor.rgb, trailColor, alpha);
    fragColor.a = max(fragColor.a, alpha);
}
