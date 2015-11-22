/* RixinCardQuery
 * @author            Phantr4x
 * @version           1.0.0
 * @last-time         2015.10.5
 */

$(document).ready(function() {
    attachClass('card-cash');
    attachClass('cny');
    $('.card').css({'margin': '0px', 'padding': '0px', 'border-radius': '0'});
    $('.card-wrapper .card-content').css({'padding': '0px', 'width': '100%'});

});

function attachClass(className) {
    return $('.'+className).addClass(className);
}
