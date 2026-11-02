namespace FCT.Operations.DataStore.Model
{
    public class DataFixHistory
    {
        private DataFixHistory()
        {
        }

        public DataFixHistory(string release, int storyNumber, string name)
        {
            Release = release;
            StoryNumber = storyNumber;
            Name = name;
        }

        public int Id { get; private set; }
        public string Release { get; private set; }
        public int StoryNumber { get; private set; }
        public string Name { get; private set; }

        public string GetKey()
        {
            return $"{Release}{StoryNumber}{Name}".ToUpper();
        }
    }
}
