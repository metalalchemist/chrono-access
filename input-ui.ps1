if('InputUI' -as [type]){return}
Add-Type @'
using System;
using System.Text;
using System.Collections.Generic;
using System.Runtime.InteropServices;
public static class InputUI {
 delegate bool EnumProc(IntPtr h,IntPtr p);
 [DllImport("user32.dll")] static extern bool EnumWindows(EnumProc cb,IntPtr p);
 [DllImport("user32.dll")] static extern bool EnumChildWindows(IntPtr h,EnumProc cb,IntPtr p);
 [DllImport("user32.dll")] static extern uint GetWindowThreadProcessId(IntPtr h,out uint pid);
 [DllImport("user32.dll",CharSet=CharSet.Unicode)] static extern int GetWindowText(IntPtr h,StringBuilder s,int n);
 [DllImport("user32.dll",CharSet=CharSet.Unicode)] static extern int GetClassName(IntPtr h,StringBuilder s,int n);
 [DllImport("user32.dll")] public static extern IntPtr GetMenu(IntPtr h);
 [DllImport("user32.dll")] static extern int GetMenuItemCount(IntPtr h);
 [DllImport("user32.dll")] static extern IntPtr GetSubMenu(IntPtr h,int i);
 [DllImport("user32.dll")] static extern uint GetMenuItemID(IntPtr h,int i);
 [DllImport("user32.dll")] static extern uint GetMenuState(IntPtr h,uint item,uint flags);
 [DllImport("user32.dll",CharSet=CharSet.Unicode)] static extern int GetMenuString(IntPtr h,uint i,StringBuilder s,int n,uint flags);
 [DllImport("user32.dll")] public static extern int GetDlgCtrlID(IntPtr h);
 [DllImport("user32.dll")] public static extern IntPtr SendMessage(IntPtr h,uint m,IntPtr w,IntPtr l);
 [DllImport("user32.dll")] public static extern bool PostMessage(IntPtr h,uint m,IntPtr w,IntPtr l);
 public static string Text(IntPtr h){var s=new StringBuilder(512);GetWindowText(h,s,s.Capacity);return s.ToString();}
 public static string Class(IntPtr h){var s=new StringBuilder(128);GetClassName(h,s,s.Capacity);return s.ToString();}
 public static IntPtr[] Windows(uint pid){var a=new List<IntPtr>();EnumWindows(delegate(IntPtr h,IntPtr p){uint id;GetWindowThreadProcessId(h,out id);if(id==pid)a.Add(h);return true;},IntPtr.Zero);return a.ToArray();}
 public static IntPtr[] Children(IntPtr h){var a=new List<IntPtr>();EnumChildWindows(h,delegate(IntPtr c,IntPtr p){a.Add(c);return true;},IntPtr.Zero);return a.ToArray();}
 public static string[] Menus(IntPtr menu){var a=new List<string>();Walk(menu,"",a);return a.ToArray();}
 static void Walk(IntPtr m,string prefix,List<string> a){for(int i=0;i<GetMenuItemCount(m);i++){var s=new StringBuilder(256);GetMenuString(m,(uint)i,s,s.Capacity,0x400);string name=prefix+s;uint id=GetMenuItemID(m,i);a.Add(id+"|"+GetMenuState(m,(uint)i,0x400)+"|"+name);IntPtr sub=GetSubMenu(m,i);if(sub!=IntPtr.Zero)Walk(sub,name+" > ",a);}}
}
'@
