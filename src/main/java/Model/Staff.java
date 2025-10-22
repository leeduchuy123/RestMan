package Model;

public class Staff {
    private String role;

    // Composition: Reference to the Member object. - staff is also a member. If member A was deleted, staff A will be gone
    // This represents the foreign key (tblMemberid) relationship in an OO manner.
    private Member member;

    public Staff() {}

    public Staff(String role, Member member) {
        this.role = role;
        this.member = member;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Member getMember() {
        return member;
    }

    public void setMember(Member member) {
        this.member = member;
    }

    @Override
    public String toString() {
        return "Staff{" +
                "role='" + role + '\'' +
                ", member=" + member +
                '}';
    }
}
