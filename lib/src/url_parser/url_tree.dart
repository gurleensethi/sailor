import 'dart:collection';

abstract class _TreeNode<T> {
  final String urlPart;
  T value;
  final Map<String, _TreeNode<T>> children = {};

  _TreeNode(this.urlPart, this.value) : assert(urlPart != null);

  @override
  String toString() {
    return '_TreeNode{urlPart: $urlPart, value: $value, children: $children}';
  }
}

class _FixedStringTreeNode<T> extends _TreeNode<T> {
  _FixedStringTreeNode(String value, T route) : super(value, route);

  @override
  String toString() {
    return '_FixedStringTreeNode{}';
  }
}

class _ParameterTreeNode<T> extends _TreeNode<T> {
  _ParameterTreeNode(String value, T route) : super(value, route);

  @override
  String toString() {
    return '_ParameterTreeNode{}';
  }
}

class UrlTree<T> {
  final _TreeNode<T> root;

  UrlTree(T homeRoute) : root = _FixedStringTreeNode<T>('/', homeRoute);

  void addUrl(String url, T value) {
    assert(url != null, "url cannot be null");
    assert(url != '/', "home route has already been registerd");
    assert(url.isNotEmpty, "url cannot be empty");
    final String cleanedUrl = _cleanUrl(url);
    _addTreeNode(cleanedUrl, value);
  }

  void _addTreeNode(String url, T value) {
    final List<String> parts = url.split('/');
    _TreeNode temp = this.root;

    for (int i = 0; i < parts.length; i++) {
      final String part = parts[i];
      final bool isParamNode = part.startsWith(":");
      final String urlPart = isParamNode ? part.substring(1) : part;
      final bool hasChild = temp.children.containsKey(urlPart);
      final bool isLastPart = i == (parts.length - 1);
      if (hasChild) {
        temp = temp.children[urlPart];
      } else {
        final _TreeNode node = isParamNode
            ? _ParameterTreeNode<T>(urlPart, null)
            : _FixedStringTreeNode<T>(urlPart, null);
        temp.children[urlPart] = node;
        temp = node;
      }

      if (isLastPart) {
        temp.value = value;
      }
    }
  }

  void printBFS() {
    final Queue<_TreeNode<T>> queue = Queue();
    queue.add(this.root);

    while (queue.isNotEmpty) {
      final _TreeNode<T> temp = queue.removeFirst();
      for (_TreeNode<T> child in temp.children.values) {
        queue.add(child);
      }
      print("$temp(${temp.urlPart}) --> ${temp.value}");
    }
  }

  String _cleanUrl(String url) {
    String cleanedUrl = url;
    if (cleanedUrl.startsWith('/')) {
      cleanedUrl = cleanedUrl.substring(1);
    }
    if (cleanedUrl.endsWith('/')) {
      cleanedUrl = cleanedUrl.substring(0, cleanedUrl.length - 1);
    }
    return cleanedUrl;
  }

  T find(String url) {
    final String cleanedUrl = _cleanUrl(url);
    final node = _find(this.root, cleanedUrl.split("/"));
    return node != null ? node.value : null;
  }

  _TreeNode _find(_TreeNode node, List<String> parts) {
    if (node == null || parts.isEmpty) {
      return null;
    }
    final String part = parts[0];
    final bool isLastPart = parts.length == 1;
    if (isLastPart && node.children.isEmpty) {
      return null;
    }
    final _TreeNode exactMatchNode = node.children[part];
    if (exactMatchNode != null) {
      if (isLastPart) {
        return exactMatchNode;
      }
      return _find(exactMatchNode, parts.sublist(1));
    } else {
      // Look for a parameter node
      for (_TreeNode<T> childNode in node.children.values) {
        if (childNode is _ParameterTreeNode<T>) {
          if (isLastPart) {
            return childNode;
          }
          final _TreeNode<T> resultNode = _find(childNode, parts.sublist(1));
          if (resultNode != null) {
            return resultNode;
          }
        }
      }
    }
    return null;
  }
}
