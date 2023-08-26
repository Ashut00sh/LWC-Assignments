public virtual class Marker {
    public virtual void write(){
        system.debug('This is virtual marker class with write method...');
    }
    public double discount(){
        system.debug('This is virtual marker class with discount method...');
        return 5.0;
    }
}