#include <cstdlib>
#include <iostream>
#include <string>
#include <windows.h>
using namespace std;

// 复制文本到剪贴板的辅助函数
void copyToClipboard(const string& text) {
  if (OpenClipboard(NULL)) {
    EmptyClipboard();
    
    // 计算需要的宽字符缓冲区大小
    int wLen = MultiByteToWideChar(CP_ACP, 0, text.c_str(), -1, NULL, 0);
    HGLOBAL hg = GlobalAlloc(GMEM_MOVEABLE, wLen * sizeof(wchar_t));
    
    if (hg) {
      wchar_t* data = (wchar_t*)GlobalLock(hg);
      if (data) {
        // 将 ANSI 字符串转换为宽字符字符串
        MultiByteToWideChar(CP_ACP, 0, text.c_str(), -1, data, wLen);
        GlobalUnlock(hg);
        SetClipboardData(CF_UNICODETEXT, hg); // 使用 Unicode 格式
      }
    }
    CloseClipboard();
  }
}

int main() {
  ios::sync_with_stdio(false);
  cin.tie(NULL);

  while (true) {
    cout << "请输入多行文本 (输入单独一行 END 结束输入并处理, 输入 exit 退出): " << endl;
    string totalResult = "";
    string line;
    bool exitProgram = false;

    // 循环读取每一行，直到遇到 END 或 exit
    while (getline(cin, line)) {
      if (line == "exit") {
        exitProgram = true;
        break;
      }
      if (line == "END") {
        break;
      }

      // 处理当前行：去除空格
      for (char c : line) {
        if (c != ' ') {
          totalResult += c;
        }
      }
      totalResult += "\r";
    }

    if (exitProgram) {
      break;
    }

    copyToClipboard(totalResult); // 自动复制到剪贴板
    cout << "(结果已复制到剪贴板)" << endl;
    system("pause");
    system("cls");
  }

  return 0;
}