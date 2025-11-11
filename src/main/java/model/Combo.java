package model;

public class Combo {
    private int id;
    private String comboname;
    private float comboprice;
    private String description;

    public Combo() {
    }

    public Combo(int id, String comboname, float comboprice, String description) {
        this.id = id;
        this.comboname = comboname;
        this.comboprice = comboprice;
        this.description = description;
    }

    public Combo(String description, float comboprice, String comboname) {
        this.description = description;
        this.comboprice = comboprice;
        this.comboname = comboname;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getComboname() {
        return comboname;
    }

    public void setComboname(String comboname) {
        this.comboname = comboname;
    }

    public float getComboprice() {
        return comboprice;
    }

    public void setComboprice(float comboprice) {
        this.comboprice = comboprice;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Combo{" +
                "id=" + id +
                ", comboname='" + comboname + '\'' +
                ", comboprice=" + comboprice +
                ", description='" + description + '\'' +
                '}';
    }
}
