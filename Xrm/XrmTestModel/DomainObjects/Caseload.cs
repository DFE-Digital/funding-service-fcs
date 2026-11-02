namespace XrmTestModel
{
    public class Caseload
    {
        public virtual Organisation Organisation { get; set; }

        public virtual User Owner { get; set; }
    }
}
