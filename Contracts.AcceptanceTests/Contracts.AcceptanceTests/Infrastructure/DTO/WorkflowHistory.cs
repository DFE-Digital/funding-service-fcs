namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    using System.Globalization;

    public class WorkflowHistory
    {
        public WorkflowHistory()
        {    
        }

        public WorkflowHistory(string action, string userName, string comment)
        {
            Action = action;
            UserName = userName;
            Comment = comment;
        }

        public string Action { get; set; }

        public string UserName { get; set; }

        public string Comment { get; set; }

        protected bool Equals(WorkflowHistory other)
        {
            return string.Equals(Action, other.Action)
                && string.Compare(UserName.Replace(" ", string.Empty),
                    other.UserName.Replace(" ", string.Empty), true, CultureInfo.InvariantCulture) == 0
                && string.Equals(Comment, other.Comment);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((WorkflowHistory) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                return ((Action?.GetHashCode() ?? 0)*397) ^ (UserName?.GetHashCode() ?? 0) ^ (Comment?.GetHashCode() ?? 0);
            }
        }

        public override string ToString()
        {
            return $"Action: {Action}, Username: {UserName}, Comment: {Comment}";
        }
    }
}
