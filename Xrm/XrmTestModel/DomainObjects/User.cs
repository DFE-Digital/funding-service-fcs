namespace XrmTestModel
{
    public class User
    {
        public string FirstName { get; set; }

        public string LastName { get; set; }

        public string Email { get; set; }

        public string Logon { get; set; }

        public virtual User Manager { get; set; }

    }
}
