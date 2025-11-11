package model;

public class ComboDish {
    private int id;
    private int quantity;
    private int tblDishId;
    private int tblComboId;

    public ComboDish(int id, int quantity, int tblDishId, int tblComboId) {
        this.id = id;
        this.quantity = quantity;
        this.tblDishId = tblDishId;
        this.tblComboId = tblComboId;
    }

    public ComboDish() {
    }

    public ComboDish(int quantity, int tblDishId, int tblComboId) {
        this.quantity = quantity;
        this.tblDishId = tblDishId;
        this.tblComboId = tblComboId;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getTblDishId() {
        return tblDishId;
    }

    public void setTblDishId(int tblDishId) {
        this.tblDishId = tblDishId;
    }

    public int getTblComboId() {
        return tblComboId;
    }

    public void setTblComboId(int tblComboId) {
        this.tblComboId = tblComboId;
    }
}
