String removeSomeString(String data) {
  data = data.replaceAll("\\t", "");
  data = data.replaceAll("\\n", "");
  data = data.replaceAll('\\r', '');
  data = data.replaceAll("\\/", "\/");
  data = data.replaceAll('\\"', '"');
  return data;
  // return "";
}
