namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    using System;
    using System.Text;

    public class TaskInfo
    {
        public string Name { get; set; }
        public string Description { get; set; }
        public string Owner { get; set; }
        public string AssignedTeam { get; set; }
        public string State { get; set; }
        public string Status { get; set; }

        public Guid Id { get; set; }

        protected bool Equals(TaskInfo other)
        {
            return string.Equals(Name, other.Name)
               && string.Equals(RemoveWhiteSpaceFromString(Description), RemoveWhiteSpaceFromString(other.Description))
               && string.Equals(Owner.ToUpper(), other.Owner.ToUpper())
               && string.Equals(AssignedTeam, other.AssignedTeam)
               && string.Equals(State, other.State)
               && string.Equals(RemoveWhiteSpaceFromString(Status), RemoveWhiteSpaceFromString(other.Status));
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((TaskInfo) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                var hashCode = (Name != null ? Name.GetHashCode() : 0);
                hashCode = (hashCode*397) ^ (Description != null ? Description.GetHashCode() : 0);
                hashCode = (hashCode*397) ^ (Owner != null ? Owner.GetHashCode() : 0);
                hashCode = (hashCode*397) ^ (AssignedTeam != null ? AssignedTeam.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ (State != null ? State.GetHashCode() : 0);
                hashCode = (hashCode * 397) ^ (Status != null ? Status.GetHashCode() : 0);
                return hashCode;
            }
        }

        private string RemoveWhiteSpaceFromString(string str)
        {
            StringBuilder sb = new StringBuilder(str.Length);
            foreach (char c in str)
            {
                if (!char.IsWhiteSpace(c))
                {
                    sb.Append(c);
                }
            }

            return sb.ToString();
        }
    }
}
