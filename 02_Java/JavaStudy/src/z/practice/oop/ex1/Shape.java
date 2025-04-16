package z.practice.oop.ex1;

public class Shape {
	private int type;
	private double height;
	private double width;
	private String color = "white";
	
	public Shape() {
		super();
	}

	public Shape(int type, double height, double width) {
		super();
		this.type = type;
		this.height = height;
		this.width = width;
	}
	
	public String information() {
		return this.height + " " + this.width + " " + this.color;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public double getHeight() {
		return height;
	}

	public void setHeight(double height) {
		this.height = height;
	}

	public double getWidth() {
		return width;
	}

	public void setWidth(double width) {
		this.width = width;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}
}
