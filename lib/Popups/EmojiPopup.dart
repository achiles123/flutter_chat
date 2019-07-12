import 'package:chat/Constants.dart';
import 'package:flutter/material.dart';

class EmojiPopup{
  BuildContext _context;
  EmojiPopup(BuildContext context){
    _context = context;
  }
  Function selectedEmo;

  void show({BuildContext context,double x,double y}){
    if(context != null)
      _context = context;
    int numberRow = Constants.emojiList.length~/12;
    numberRow += Constants.emojiList.length%12 == 0?0:1;
    double height = (MediaQuery.of(_context).size.width-x*2)/12;
    showDialog(
      context: _context,
      barrierDismissible: true,
      builder: (context){
        return Stack(
          children: <Widget>[
            Positioned(
              left: x,
              bottom: y,
              child: Container(
                height: numberRow*height,
                width: MediaQuery.of(context).size.width-x*2,
                decoration: BoxDecoration(
                  color: Colors.transparent
                ),
                child: Builder(
                  builder: (context){
                    return GridView.builder(
                      padding: EdgeInsets.all(0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 12,
                      ),
                      itemCount: Constants.emojiList.length,
                      itemBuilder: (context,index){
                        String keyEmo = Constants.emojiList.keys.elementAt(index);
                        return Material(
                          child: InkWell(
                            onTap: (){
                              selectedEmo(keyEmo);
                            },
                            child: Container(
                              height: height,
                              width: height,
                              child: Image.asset(Constants.emojiList[keyEmo],fit: BoxFit.fill,),
                            )
                          ),
                        );
                      },
                    );
                  },
                )
              ),
            )
          ],
        );
      }
    );
  }

  Widget _buildMaterialDialogTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: child,
    );
  }

  Future<T> showDialog<T>({
    @required BuildContext context,
    bool barrierDismissible = true,
    @Deprecated(
      'Instead of using the "child" argument, return the child from a closure '
      'provided to the "builder" argument. This will ensure that the BuildContext '
      'is appropriate for widgets built in the dialog.'
    ) Widget child,
    WidgetBuilder builder,
  }) {
    assert(child == null || builder == null);
    assert(debugCheckHasMaterialLocalizations(context));

    final ThemeData theme = Theme.of(context, shadowThemeOnly: true);
    return showGeneralDialog(
      context: context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        final Widget pageChild = child ?? Builder(builder: builder);
        return SafeArea(
          child: Builder(
            builder: (BuildContext context) {
              return theme != null
                  ? Theme(data: theme, child: pageChild)
                  : pageChild;
            }
          ),
        );
      },
      barrierDismissible: barrierDismissible,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black54.withOpacity(0.01),
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: _buildMaterialDialogTransitions,
    );
  }
}