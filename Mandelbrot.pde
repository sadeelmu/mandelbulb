import peasy.*;

int dim = 128;

PeasyCam cam; //Allows us to set up a camera that centers our render and move the render around

ArrayList<PVector> mandelbulb = new ArrayList<PVector>();

class Spherical {
  float r, theta, phi;
  Spherical(float r, float theta, float phi) {
    this.r = r;
    this.theta = theta;
    this.phi = phi;
  }
} 


//convert to spherical coordinates
Spherical spherical(float x, float y, float z) {
     float r = sqrt(x*x + y*y + z*z);
      float theta = atan2(sqrt(x*x + y*y), z);
      float phi = atan2(y,x);
      return new Spherical(r, theta, phi);
}

void setup() {
  
  //set up window and cam
  size(600, 600, P3D);
  windowMove(1200, 100);
  cam = new PeasyCam(this, 350); 
  
  //set up Mandel Bulb set
    for (int i = 0; i < dim; i++){
      for (int j = 0; j < dim; j++){
        //optimization
        boolean edge = false;
          for (int k = 0; k < dim; k++){
               float x = map(i, 0, dim, -1, 1);
               float y = map(j, 0, dim, -1, 1);
               float z = map(k, 0, dim, -1, 1);
               
               PVector zeta = new PVector(0, 0, 0);

              int iterations = 0;
              int n = 16;
              int maxiterations = 10;

               while(true){
               Spherical sphericalZeta = spherical(zeta.x, zeta.y, zeta.z);

               float newx = pow(sphericalZeta.r, n) * sin(sphericalZeta.theta*n) * cos(sphericalZeta.phi*n);
               float newy = pow(sphericalZeta.r, n) * sin(sphericalZeta.theta*n) * sin(sphericalZeta.phi*n);
               float newz = pow(sphericalZeta.r, n) * cos(sphericalZeta.theta*n);               
               
               //adding constant c
               zeta.x = newx + x;
               zeta.y = newy + y;
               zeta.z = newz + z;
               
               iterations++;
               
                 if (sphericalZeta.r > 16){
                   if(edge){
                     edge = false; 
                   }
                     
                   break;
                 }
                 
                 if(iterations > maxiterations){
                   //reached bound
                   if(!edge){
                     edge = true;
                   //add each point calcualted into array after exceeding max iterations
                   mandelbulb.add(new PVector(x*100, y*100, z*100));
                   }
                   break;
                 }
          
               }
            }
        }
    }
}


void draw() {
  background(0);

  for(PVector v : mandelbulb){
    stroke(255);
    point(v.x, v.y, v.z);
  }
}
