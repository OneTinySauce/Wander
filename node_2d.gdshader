shader_type canvas_item;
uniform float outline_width = 2.0;
uniform vec4 outline_color : source_color;

//uniform sampler2D normalmap :source_color;
uniform sampler2D noiseVor :source_color;
uniform float pi = 3.141;



// функция для рандомного значения 
//Random value https://godotshaders.com/snippet/random-value/
float random2 (vec2 uv) {
    return fract(sin(dot(uv.xy,
        vec2(12.9898,78.233))) * 43758.5453123);
}
vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}
// тут будет функция оопределяющая силу смещения относительно текущей точки
float motionCysle(float time){
	return 0.9*cos(pi*sin(time+1.0))+ 1.0*sin(cos(time)*4.0+1.3)+  0.05*random2(vec2 (time,time))+ 1.3*sin(cos(time)*4.0+1.3);
}
// текстура вороного
vec2 voronoi(vec2 uv, float columns, float rows, float time) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	vec2 minimum_point;

	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor)*(1.9 - sin(time));

			vec2 diff = neighbor + point - fract_uv + 1.9 - sin(time);
			float dist = length(diff);
			
			if(dist < minimum_dist) {
				minimum_dist = dist;
				minimum_point = point;
			}
		}
	}
	return minimum_point;
}
// текстура Worley 
float worley(vec2 uv, float columns, float rows,float  time) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor) *(1.9 - sin(time));
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			minimum_dist = min(minimum_dist, dist);
		}
	}
	
	return minimum_dist;
}





void fragment() {
	// изначальная текстура которая будет исппользыватся для формирования ободки
	// далее случайные пиксели обводки будут удолятся что создась нбольшую илюзию движения
	vec4 col = texture(TEXTURE, UV);
	vec2 ps = TEXTURE_PIXEL_SIZE;
	

	float maxa = col.a;
	float mina = col.a;
	// обводка в настоящий момент не работает, нужно будет фиксить
	// -----------------------------------
	vec4 Oultine = mix(col, outline_color, maxa - mina);
	
	// определяет размер для пикселезации
	float size_x = float(textureSize(TEXTURE, 0).x);
	float size_y = float(textureSize(TEXTURE, 0).y);
	// размер пиксилизации но можно сделать пиксели шума смещениия больше
	float size_xn = float(textureSize(TEXTURE, 0).x)/8.0;
	float size_yn = float(textureSize(TEXTURE, 0).y)/8.0;
	// UV с пиксилизацией
	vec2 UVr = vec2(floor(UV.x*size_x)/size_x , floor(UV.y*size_y)/size_y);
	vec2 UVn = vec2(floor(UV.x*size_xn)/size_xn , floor(UV.y*size_yn)/size_yn);
	
	// формирование шума мб нужно переделать
	vec4 noise ;
	noise.r = random2(UVn);
	noise.b = random2(UVn);
	noise.g = random2(UVn);

	
	
	// шум фороного из юниформ
	vec4 noiseVarr = texture(noiseVor,UVr);
	noise.a = round(noiseVarr.r-0.1)*Oultine.a;
	COLOR.a += noise.a;
	
	
	
	vec4 sin_col;
	
	sin_col.r = UVr.x*cos(TIME/2.0) +UVr.y*3.0*(motionCysle(TIME)  );
	// это сгенерированый тут же шум
	//vec3 voronoi = vec3(voronoi(UVr, 9.0, 5.0, TIME).r);
	//vec3 worley =vec3(worley(UVr, 3.0, 5.0, TIME));
	
	// итоговая uv для смещения оригинальной текстуры
	vec2 uv = UVr;
	// к итоговой uv смещение прибовляется значение пикселя смещения
	// и в итоге пиксель берет цет лежаший на каком то растоянии в uv развертке от него
	uv.x+=0.01 -0.8*((noiseVarr.r+noise.r)/size_x + sin_col.r/(size_x *15.0));
	uv.y+=0.01 - 0.8*(noiseVarr.r/size_y + sin_col.r/(size_y*15.0));
	
	vec4 color = texture(TEXTURE, uv);
	
	COLOR.rgb = color.rgb;
	
	
	//NORMAL_MAP = texture(normalmap, uv).xyz + noise.b*0.2; 


}

