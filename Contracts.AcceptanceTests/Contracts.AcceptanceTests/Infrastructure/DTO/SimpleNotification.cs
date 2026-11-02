namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    using System.Text;

    public class SimpleNotification
    {
        public SimpleNotification(string status, string notificationName, string notificationText)
        {
            Status = status;
            NotificationName = notificationName;
            NotificationText = notificationText;
        }

        public string Status { get; }

        public string NotificationName { get; }

        public string NotificationText { get; }

        protected bool Equals(SimpleNotification other)
        {
            return AreStringsEqual(Status, other.Status) && AreStringsEqual(NotificationName, other.NotificationName) && AreStringsEqual(NotificationText, other.NotificationText);
        }

        public override bool Equals(object obj)
        {
            if (ReferenceEquals(null, obj)) return false;
            if (ReferenceEquals(this, obj)) return true;
            if (obj.GetType() != this.GetType()) return false;
            return Equals((SimpleNotification) obj);
        }

        public override int GetHashCode()
        {
            unchecked
            {
                var hashCode = (Status != null ? Status.GetHashCode() : 0);
                hashCode = (hashCode*397) ^ (NotificationName != null ? NotificationName.GetHashCode() : 0);
                hashCode = (hashCode*397) ^ (NotificationText != null ? NotificationText.GetHashCode() : 0);
                return hashCode;
            }
        }

        public static bool operator ==(SimpleNotification left, SimpleNotification right)
        {
            return Equals(left, right);
        }

        public static bool operator !=(SimpleNotification left, SimpleNotification right)
        {
            return !Equals(left, right);
        }

        public override string ToString()
        {
            return $"Status: {Status}, NotificationName: {NotificationName}, NotificationText: {NotificationText}";
        }

        private bool AreStringsEqual(string s1, string s2)
        {
            return RemoveWhiteSpaceFromString(s1).Equals(RemoveWhiteSpaceFromString(s2));
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
