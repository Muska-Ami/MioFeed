import 'dart:io';

class FsUtils {
  /// 异步函数，用于删除目录及其内容
  static Future<void> deleteDirectory(Directory directory) async {
    // 如果目录存在
    if (await directory.exists()) {
      // 列出目录下的所有内容，包括文件和子目录
      List<FileSystemEntity> contents = directory.listSync();

      // 遍历所有内容
      for (FileSystemEntity entity in contents) {
        if (entity is File) {
          // 如果是文件，直接删除
          await entity.delete();
        } else if (entity is Directory) {
          // 如果是子目录，递归调用自己删除子目录及其内容
          await deleteDirectory(entity);
        }
      }

      // 删除空目录
      await directory.delete();
    }
  }
}
