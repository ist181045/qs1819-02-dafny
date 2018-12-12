/*
 * This is the skeleton for your cp utility.
 *
 * Rui Maranhao -- rui@computer.org
 */

include "Io.dfy"

// Useful to convert Dafny strings into arrays of characters.
method ArrayFromSeq<A>(s: seq<A>) returns (a: array<A>)
  ensures a[..] == s
{
  a := new A[|s|] ( i requires 0 <= i < |s| => s[i] );
}

method {:main} Main(ghost env: HostEnvironment?)
  requires env != null && env.Valid() && env.ok.ok() && !env.ow.ow()
  requires
      var args := env.constants.CommandLineArgs();
      var files := env.files.state();
      |args| == 3
      && args[1] in files && |files[args[1]]| >= 0
  modifies env.ok
  modifies env.ow
  modifies env.files
  ensures env.ok.ok() ==>
      var args := env.constants.CommandLineArgs();
      var files := env.files.state();
      args[2] in files && env.ow.ow() ==> args[2] in old(files)
{
  var argc := HostConstants.NumCommandLineArgs(env);
  if argc != 3 {
    print "Usage: cp <source> <destination>\n";
    return;
  }

  var ok: bool;
  var src := HostConstants.GetCommandLineArg(1, env);
  var dst := HostConstants.GetCommandLineArg(2, env);
  
  ok := FileStream.FileExists(src, env); assert ok;
  ok := FileStream.FileExists(dst, env);
  if ok {
    var yes := HostConstants.AskForOverwrite(dst, env);
    if !yes {
      return;
    }
  }
  
  var len; ok, len := FileStream.FileLength(src, env);
  if !ok {
    print "Failed to get length of source file '"; print src; print "'\n";
    return;
  }

  var ifs; ok, ifs := FileStream.Open(src, env);
  if !ok {
    print "Failed to open source file '"; print src; print "'\n";
    return;
  }
  
  var buffer := new byte[len];
  ok := ifs.Read(0, buffer, 0, len);
  if !ok {
    print "Failed to read source file '"; print src; print "'\n";
    return;
  }

  ok := ifs.Close();
  if !ok {
    print "Failed to close source file '"; print src; print "'\n";
    return;
  }

  var ofs; ok, ofs := FileStream.Open(dst, env);
  if !ok {
    print "Failed to open/create destination file: "; print dst; print "\n";
    return;
  }
  
  ok := ofs.Write(0, buffer, 0, len);
  if !ok {
    print "Failed to write to destination file '"; print dst; print "'\n";
    return;
  }

  ok := ofs.Close();
  if !ok {
    print "Failed to close destination file '"; print dst; print "'\n";
    return;
  }

  print "'"; print src; print "' -> '"; print dst; print "'\n";
}
