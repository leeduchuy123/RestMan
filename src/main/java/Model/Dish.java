package Model;

public class Dish {
    private int id;
    private String dishname;
    private float dishprice;
    private String description;

    public Dish() {
    }

    public Dish(String dishname, float dishprice, String description) {
        this.dishname = dishname;
        this.dishprice = dishprice;
        this.description = description;
    }

    public Dish(int id, String dishname, float dishprice, String description) {
        this.id = id;
        this.dishname = dishname;
        this.dishprice = dishprice;
        this.description = description;
    }

    public String getDishname() {
        return dishname;
    }

    public void setDishname(String dishname) {
        this.dishname = dishname;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public float getDishprice() {
        return dishprice;
    }

    public void setDishprice(float dishprice) {
        this.dishprice = dishprice;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Dish{" +
                "id=" + id +
                ", dishname='" + dishname + '\'' +
                ", dishprice=" + dishprice +
                ", description='" + description + '\'' +
                '}';
    }
}
